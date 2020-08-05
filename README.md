# SelectGoodFace
#### [[Project](http://efrosprojects.eecs.berkeley.edu/mirrormirror/)] [[Paper](http://efrosprojects.eecs.berkeley.edu/mirrormirror/mirrormirror.pdf)]
Contact: Jun-Yan Zhu (junyanz at cs dot cmu dot edu)

## Overview
This program can select attractive/serious portraits from a personal photo collection. Given the photo collection of the *same* person as input, our program computes the attractiveness/seriousness scores on all the faces. The scores are predicted by the SVM models pre-trained on the face data that we collected for our paper.

The program assumes only one person in each input image. Please use other software (e.g. Picasa) to identify and localize the subject before running our code. See Section 8 and Figure 17 in the paper for details.

The code can only be used for non-commercial purposes. Please cite the following work if you use our code and data for your research:

[Mirror Mirror: Crowdsourcing Better Portraits](http://efrosprojects.eecs.berkeley.edu/mirrormirror/)  
[Jun-Yan Zhu](https://www.cs.cmu.edu/~junyanz/), [Aseem Agarwala](http://www.agarwala.org/), [Alexei A. Efros](https://people.eecs.berkeley.edu/~efros/), [Eli Shechtman](https://research.adobe.com/person/eli-shechtman/), [Jue Wang](http://www.juew.org/)  
In ACM Transactions on Graphics (Proceedings of SIGGRAPH Asia 2014)  

[Project Page](http://efrosprojects.eecs.berkeley.edu/mirrormirror/)

Please cite our paper if you use our code for your research.
```
@article{zhu2014mirror,
 author = {Jun-Yan Zhu and Aseem Agarwala and Alexei A Efros and Eli Shechtman and Jue Wang},
 title = {Mirror Mirror: Crowdsourcing Better Portraits},
 journal = {ACM Transactions on Graphics (SIGGRAPH Asia 2014)},
 volume = {33},
 number = {6},
 year = {2014},
}
```

## Installation
* Download and unzip the code.
* Install face tracker: our program currently supports two face trackers:
  - IntraFace: download the MATLAB version from http://www.humansensing.cs.cmu.edu/intraface/ and put the software in the "IntraFace" folder.
  - CLM-Wild:  download "DRMF Code Version 2.0" from (https://sites.google.com/site/akshayasthana/clm-wild-code)
   and put the software in the "CLMWILD" folder.
* Download the test face dataset:  run "DownloadFaceData.m" to get the face images from http://chenlab.ece.cornell.edu/people/Andy/GallagherDataset.html
* Run "SelectGoodFace.m" to rank the faces by attractiveness and seriousness. "SelectGoodFace.m" is the main entry function. You can find the results in "data/demo/&lt;CONF.tracker&gt;\_result".
* Modify the configuration file "SetConfig.m" if you want to run the code on your own data.


## System Requirement
* Windows and Linux.
* Mex files compiled on 64-bit Windows and Linux (features31.mexw64, features31.mexa64) are provided. If they don't work for you, compile "features31.cc". (mex features31.cc)


## Notes on face trackers
* We used IntraFace in our paper. However, IntraFace is temporally suspended according to the authors' website. I will update my code once the new version of IntraFace is released. CLM-WILD tracker is publicly available now.
* You can also use other face tracker as you like. Please modify the Line 40~44 in "SelectGoodFace.m" and write your own wrapper to adapt other face trackers. For each image, my code needs:
  - Nine facial points:  \[9x2 double\] (see "points.png")
  - 3D pose (Pitch, Yaw, Roll): \[3x1 double\] (set the pose as \[ \] if your face tracker doesn't provide pose information)
  - Confidence score: set the confidence score as 1 if your face tracker doesn't provide the confidence score.
* For "the Gallagher Collection Person Dataset", I provided the precomputed facial points ("data/demo/IntraFace_cache/detection.mat") detected by IntraFace so that you can reproduce the first row of Figure 17 in our paper.


## Usage
* Input: please set the image folder and the parameters in "SetConfig.m"
    - Folder: set CONF.dataFold as your data folder
    - Images: You need to put your images in CONF.dataFold/imgs/
    - Tracker: You need to specify your tracker in "CONF.tracker" (IntraFace, CLMWILD). We included pre-trained SVM models for different trackers. (e.g. models/CLMWILD_attractive_model.mat for CLM-Wild tracker; models/IntraFace_attractive_model.mat for IntraFace tracker, etc. )
    - Parameters for filtering out "bad" faces:
      * CONF.smallFace = 250;       % ignore small face
      * CONF.poseThres = 15;        % ignore non-frontal face (e.g. 15 degree)
      * CONF.trackConfThres = 0.5;  % ignore tracking failure (e.g. confidence <0.5)
      * CONF.alignErrorThres = 8;   % ignore poor alignment (e.g. mean pixel error > 8)
* Output: our program outputs ranking results for both attractiveness and seriousness in the following folder: CONF.dataFold/[CONF.tracker '\_result']

## Acknowledgement
Part of the face alignment code is based on the work by Fei Yang.
