package com.team12.veterinaryWebServices.viewmodel;

import com.team12.veterinaryWebServices.model.comment;

import java.util.Date;

public record commentVM(Long commentID, String profileIMG, String profileNAME, Date commentDATE, int commentRATING ,String CONTENT) {
    public static commentVM from(comment c) {

        return new commentVM(
                c.getCommentID(),
                c.getProfile().getProfileIMG(),
                c.getProfile().getProfileNAME(),
                c.getCommentDATE(),
                c.getCommentRATING(),
                c.getCONTENT()
        );
    }
}
