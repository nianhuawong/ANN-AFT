# coding:utf-8
from __future__ import print_function
import tensorflow as tf
# import matplotlib.pyplot as plt
import numpy as np
import os
# import random
# import math
import matplotlib as mpl
from codes import nngen_forward_step
mpl.rcParams['font.family'] = 'sans-serif'  # config the matplot
mpl.rcParams['font.sans-serif'] = 'NSimSun,Times New Roman'

BATCH_SIZE = 10
LEARNING_RATE_BASE = 0.01
LEARNING_RATE_DECAY = 0.9  # 学习衰减率
REGULARIZER = 0.0001
STEPS = 100000

MODEL_SAVE_PATH = "../model/airfoil/"
MODEL_NAME="step_model"

number_of_each_group = 11  # 11为4个输入点，1个答案点，一个model

train_data_raw = np.loadtxt('../training_data/train_data_output_1114_air.txt', delimiter=',', unpack=True)
train_data_raw_len=len(train_data_raw)
train_data_nn_group=train_data_raw_len//11  # 一组11个数

train_data_nn=[]
y_ref=[]

for i in range(train_data_nn_group):
    train_data_nn.append([])
    y_ref.append([])
    for j in range(8):
        train_data_nn[i].append(train_data_raw[i*11+j])
    for k in range(3):
        y_ref[i].append(train_data_raw[i*11+8+k])


i=i+1
train_data_nn.append([])
y_ref.append([])
train_data_nn[i].append(-1.09)
train_data_nn[i].append(0)
train_data_nn[i].append(0)
train_data_nn[i].append(0)
train_data_nn[i].append(1)
train_data_nn[i].append(0)
train_data_nn[i].append(0.01)
train_data_nn[i].append(-0.14)
y_ref[i].append(0.5)
y_ref[i].append(0.866)
y_ref[i].append(1)


# i=i+1
# train_data_nn.append([])
# y_ref.append([])
#
# train_data_nn[i].append(-0.22)
# train_data_nn[i].append(1.49)
# train_data_nn[i].append(0)
# train_data_nn[i].append(0)
# train_data_nn[i].append(1)
# train_data_nn[i].append(0)
# train_data_nn[i].append(1)
# train_data_nn[i].append(1.42)
# y_ref[i].append(0.5)
# y_ref[i].append(0.866)
# y_ref[i].append(2)


y_ref_len=len(y_ref)
train_data_nn_len=len(train_data_nn)

def backward():
    #占位
    with tf.name_scope('inputs'):
        x_data = tf.placeholder(tf.float32, [None, nngen_forward_step.INPUT_NODE], name='x_input')
        y_target = tf.placeholder(tf.float32, [None, nngen_forward_step.OUTPUT_NODE], name='y_input')
    
    final_output = nngen_forward_step.forward(x_data, REGULARIZER)
    
    # 2定义损失函数及反向传播方法。
    global_step = tf.Variable(0, trainable=False)
    learning_rate = tf.train.exponential_decay(LEARNING_RATE_BASE, global_step, (y_ref_len-1) / BATCH_SIZE, LEARNING_RATE_DECAY,staircase=True)

    # 定义损失函数为MSE,反向传播方法为梯度下降。
    with tf.name_scope('loss'):
        loss = tf.reduce_mean(tf.square(y_target - final_output))  # y_target是个list，而final_output是arry，对应每行相减，最后求总和求平均
        # tf.scalar_summary('loss',loss)
        tf.summary.scalar('loss', loss)

    with tf.name_scope('train'):
        train_step = tf.train.GradientDescentOptimizer(learning_rate).minimize(loss, global_step=global_step)

    saver = tf.train.Saver()
    # 3生成会话，训练STEPS轮
    with tf.Session() as sess:
        # merged = tf.merge_all_summaries()
        # writer = tf.train.SummaryWriter("logs_2/", sess.graph)
        merged = tf.summary.merge_all()
        writer = tf.summary.FileWriter("../model/airfoil/log/", sess.graph)
        init_op = tf.global_variables_initializer()
        sess.run(init_op)

        ckpt = tf.train.get_checkpoint_state(MODEL_SAVE_PATH)
        if ckpt and ckpt.model_checkpoint_path:
            saver.restore(sess, ckpt.model_checkpoint_path)

        for i in range(STEPS):            # for is 0-steps-1 ,has been vertify the i is 0- step-1,
            start = (i*BATCH_SIZE) % y_ref_len
            end = (i*BATCH_SIZE) % y_ref_len + BATCH_SIZE

            # start = 18619
            # end = 18620

            # pp=train_data_nn[start:end]  #取的数据的第0-2行，但不包含第二行，其实就是第0和第1行
            # m=i%100
            # xm=train_data_nn[start:end]
            # ym=y_ref[start:end]
            
            _,loss_v,step=sess.run([train_step,loss, global_step], feed_dict={x_data: train_data_nn[start:end], y_target: y_ref[start:end]})

            if i % 50 == 0:
                result = sess.run(merged, feed_dict={x_data: train_data_nn[start:end], y_target: y_ref[start:end]})
                writer.add_summary(result, i)
            if i % 500 == 0:

                saver.save(sess, os.path.join(MODEL_SAVE_PATH, MODEL_NAME), global_step=global_step)
                print("After %d steps, loss is: %f" % (step, loss_v))

def main():
    backward()


if __name__ == '__main__':
    main()
