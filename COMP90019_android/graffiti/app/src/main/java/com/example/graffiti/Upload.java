/*
  Upload.java
  Graffiti
  Upload class : pack all data into an object for upload.
  Created by Xiaoshu Chen on 2019/10/18.
  Copyright © 2019 Xiaoshu All rights reserved.
*/
package com.example.graffiti;

public class Upload {
    private String mUid;
    private String mDes;
    private String mLocation;
    private String mTag;
    private String mLabel;
    private String mIsGraffiti;


    public Upload() {
        //empty constructor needed
    }

    public Upload(String uid, String description, String tag, String location, String Labels, String isGraffiti) {
        if (description.trim().equals("")) {
            description = "No Description";
        }
        if (location == null) {
            location = "No location";
        }
        if (Labels == null) {
            Labels = "No matched labels!";
        }

        mTag = tag;
        mUid = uid;
        mDes = description;
        mLocation = location;
        mLabel = Labels;
        mIsGraffiti = isGraffiti;
    }

    public String getTag() {return mTag;}

    public void setTag(String tag) {mTag = tag;}

    public String getDescription() {
        return mDes;
    }

    public void setDescription(String description) {
        mDes = description;
    }

    public String getUid() { return mUid; }

    public String getLocation() {
        return mLocation;
    }

    public String getLabel() {
        return mLabel;
    }

    public void setLabel(String label) {
        mLabel = label;
    }

    public String getGraffiti() {
        return mIsGraffiti;
    }

}