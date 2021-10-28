# coding:utf-8
import tensorflow as tf
import numpy as np
import os
import forward_step

MODEL_SAVE_PATH = "../iso_triangle_model/variables/"
MODEL_NAME = "naca0012_tri_model"

REGULARIZER = 0.0001
BATCH_SIZE = 200
LEARNING_RATE_BASE = 0.1
LEARNING_RATE_DECAY = 0.96

STEPS = 200000

input_data = np.loadtxt('../iso_triangle_data/naca0012-tri-input.dat',  dtype=float, delimiter='\t ', unpack=True)
label_data = np.loadtxt('../iso_triangle_data/naca0012-tri-output.dat', dtype=float, delimiter='\t ', unpack=True)
input_data = input_data.transpose()
label_data = label_data.transpose()

dataset_size = len(input_data)

def backward():
    with tf.name_scope(''):
        x_data = tf.placeholder(tf.float32, [None, forward_step.INPUT_NODE], name='input')
        y_target = tf.placeholder(tf.float32, [None, forward_step.OUTPUT_NODE], name='ouput')

    final_output = forward_step.forward(x_data, REGULARIZER)
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
        # init_op = tf.global_variables_initializer()
        # sess.run(init_op)
        tf.global_variables_initializer().run()

        ckpt = tf.train.get_checkpoint_state(MODEL_SAVE_PATH)
        if ckpt and ckpt.model_checkpoint_path:
            saver.restore(sess, ckpt.model_checkpoint_path)

        for iStep in range(STEPS):
            start = (iStep * BATCH_SIZE) % dataset_size
            end = min(start+BATCH_SIZE, dataset_size)
            tmp = input_data[start:end]
            _, loss_v, step = sess.run([train_step, loss, global_step],
                                       feed_dict={x_data: input_data[start:end], y_target: label_data[start:end]})

            if step % 1000 == 0:
                saver.save(sess, os.path.join(MODEL_SAVE_PATH, MODEL_NAME), global_step=global_step)
                print("After %d steps, loss is: %f" % (step, loss_v))

        graph_def1 = tf.get_default_graph().as_graph_def()
        graph_def2 = sess.graph_def
        constant_graph = tf.graph_util.convert_variables_to_constants(sess, sess.graph_def, ['output'])
        with tf.gfile.GFile("../iso_triangle_model/saved_model.pb", mode="wb") as f:
            f.write(constant_graph.SerializeToString())
        # tf.train.write_graph(sess.graph_def, '../iso_triangle_model/', 'saved_model.pb.ascii', as_text=True)


def main():
    backward()


if __name__ == '__main__':
    main()
