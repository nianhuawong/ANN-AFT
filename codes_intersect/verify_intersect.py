# -*- coding: utf-8 -*-
"""
Created on Sat Apr  4 11:53:31 2020

@author: Wang Nianhua
"""

import tensorflow as tf
import intersec_forward_step
import time
import numpy as np

EVAL_INTERVAL_SECS = 10
MODEL_SAVE_PATH = "./model/intersect/"
MODEL_NAME = "intersect_model"

validate_data = np.loadtxt('./validate_data_intersect.dat', delimiter='\t', unpack=True)
validate_data = validate_data.transpose()

dataset_size = len(validate_data)

X_valid = np.zeros((dataset_size, 8))
Y_valid = np.zeros((dataset_size, 1))

for i in range(dataset_size):
    Y_valid[i][0] = validate_data[i][8]
    for j in range(8):
        X_valid[i][j] = validate_data[i][j]


def verify():
    with tf.Graph().as_default() as g:
        x = tf.placeholder(tf.float32,[None,intersec_forward_step.INPUT_NODE], name='x-input')
        y_= tf.placeholder(tf.float32,[None,intersec_forward_step.OUTPUT_NODE], name='y-input')
        
        validate_feed = {x:X_valid, y_:Y_valid}
        y = intersec_forward_step.forward(x,None)
        
        accuracy = tf.reduce_mean(tf.square(y - y_))
        
        saver = tf.train.Saver() 
        while True:
            with tf.Session() as sess:
                ckpt = tf.train.get_checkpoint_state(MODEL_SAVE_PATH)
            
                if ckpt and ckpt.model_checkpoint_path:                
                    saver.restore(sess, ckpt.model_checkpoint_path)            
                    global_step = ckpt.model_checkpoint_path.split('/')[-1].split('-')[-1]           
                    accuracy_score = sess.run(accuracy, feed_dict=validate_feed)           
                    print("After %s training steps, validation accuracy = %g" %(global_step,accuracy_score))
                    
                    data = [y]
                    file = open('out.dat','w')
                    file.write(str(data))
                    file.close()
                    
                else:
                    print('No checkpoint file found!')
                    return
            time.sleep(EVAL_INTERVAL_SECS)
            

def main():
    verify()
    
if __name__ == '__main__':
    main()