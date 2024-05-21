import cv2
import numpy as np

# cap = cv2.VideoCapture("rtsp://192.168.20.201:8554/stream1")
# arr_cap = []
# for i in range(15):
#     i = 0
#     cap = cv2.VideoCapture("rtspsrc location=rtsp://192.168.20.2%02d:8554/stream1 latency=0 ! decodebin ! nvvidconv ! video/x-raw,format=BGRx ! videoconvert ! video/x-raw,format=BGR ! appsink drop=1"%(i+1), cv2.CAP_GSTREAMER)

# def check_open(arr_cap):

# width = int(arr_cap[0].get(cv2.CAP_PROP_FRAME_WIDTH))
# height = int(arr_cap[0].get(cv2.CAP_PROP_FRAME_HEIGHT))

# cap1 = cv2.VideoCapture("rtspsrc location=rtsp://192.168.20.161:8554/stream1 latency=0 ! decodebin ! nvvidconv ! video/x-raw,format=BGRx ! videoconvert ! video/x-raw,format=BGR ! appsink drop=1", cv2.CAP_GSTREAMER)
# cap2 = cv2.VideoCapture("rtspsrc location=rtsp://192.168.20.161:8554/stream1 latency=0 ! decodebin ! nvvidconv ! video/x-raw,format=BGRx ! videoconvert ! video/x-raw,format=BGR ! appsink drop=1", cv2.CAP_GSTREAMER)
cap1 = cv2.VideoCapture("rtsp://192.168.20.161:8554/stream1")
cap2 = cv2.VideoCapture("rtsp://192.168.20.166:8554/stream1")

width = int(cap1.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(cap1.get(cv2.CAP_PROP_FRAME_HEIGHT))
while(cap1.isOpened()):
    ret1, frame1 = cap1.read()
    cv2.putText(frame1,'Camera 01',(5,50), cv2.FONT_HERSHEY_PLAIN, 4, (255, 255, 255), 5, cv2.LINE_AA)
    ret2, frame2 = cap2.read()
    frame1 = cv2.resize(frame1, (width//2, height//2))
    frame2 = cv2.resize(frame2, (width//2, height//2))
    img = np.hstack((frame1, frame2))
    cv2.imshow('frame', img)
    if cv2.waitKey(20) & 0xFF == ord('q'):
        break
cap1.release()
cv2.destroyAllWindows()

# https://www.raspberrypi.com/documentation/computers/camera_software.html#libcamera-and-libcamera-apps
# rpicam-vid -t 0 --inline -o - | cvlc stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/stream1}' :demux=h264

# screen -S x "rpicam-vid -t 0 --inline -o - | cvlc stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/stream1}' :demux=h264"