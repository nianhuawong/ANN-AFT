# coding:utf-8
import tensorflow as tf
import numpy as np
import os
import intersec_forward_step

MODEL_SAVE_PATH = "./model/intersect/"
MODEL_NAME = "intersect_model"

REGULARIZER = 0.0001
BATCH_SIZE = 200
LEARNING_RATE_BASE = 0.1
LEARNING_RATE_DECAY = 0.96

STEPS = 3000000

train_data = np.loadtxt('./train_data_intersect.dat', delimiter='\t', unpack=True)
train_data = train_data.transpose()

dataset_size = len(train_data)

X = np.zeros((dataset_size, 8))
Y = np.zeros((dataset_size, 1))

for i in range(dataset_size):
    Y[i][0] = train_data[i][8]
    for j in range(8):
        X[i][j] = train_data[i][j]


def backward():
    with tf.name_scope('inputs'):
        x_data = tf.placeholder(tf.float32, [None, intersec_forward_step.INPUT_NODE], name='x_input')
        y_target = tf.placeholder(tf.float32, [None, intersec_forward_step.OUTPUT_NODE], name='y_input')

    final_output = intersec_forward_step.forward(x_data, REGULARIZER)
    global_step = tf.Variable(0, trainable=False)
    learning_rate = tf.train.exponential_decay(LEARNING_RATE_BASE, global_step,  dataset_size / BATCH_SIZE,
                                               LEARNING_RATE_DECAY, staircase=True)

    with tf.name_scope('loss'):
        loss = tf.reduce_mean(tf.square(y_target - final_output))
        tf.summary.scalar('loss', loss)

    with tf.name_scope('train'):
        train_step = tf.train.GradientDescentOptimizer(learning_rate).minimize(loss, global_step=global_step)

    saver = tf.train.Saver()
    with tf.Session() as sess:
        init_op = tf.global_variables_initializer()
        sess.run(init_op)

        ckpt = tf.train.get_checkpoint_state(MODEL_SAVE_PATH)
        if ckpt and ckpt.model_checkpoint_path:
            saver.restore(sess, ckpt.model_checkpoint_path)

        for iStep in range(STEPS):
            start = (iStep * BATCH_SIZE) % dataset_size
            end = min(start+BATCH_SIZE, dataset_size)

            _, loss_v, step = sess.run([train_step, loss, global_step],
                                       feed_dict={x_data: X[start:end], y_target: Y[start:end]})

            if iStep % 500 == 0:
                saver.save(sess, os.path.join(MODEL_SAVE_PATH, MODEL_NAME), global_step=global_step)
                print("After %d steps, loss is: %f" % (step, loss_v))


def main():
    backward()


if __name__ == '__main__':
    main()