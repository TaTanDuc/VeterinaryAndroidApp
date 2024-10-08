package com.team12.veterinaryWebServices.viewmodel;


import com.team12.veterinaryWebServices.model.service;
import com.team12.veterinaryWebServices.repository.commentRepository;

import java.util.List;


public record serviceVM (String serviceCODE, String serviceNAME, double serviceRATING, int commentCOUNT, String serviceDATE){

    private static commentRepository commentRepository;

    public static serviceVM from (service s){
        return new serviceVM(
                s.getServiceCODE(),
                s.getServiceNAME(),
                s.getServiceRATING(),
                (int) s.getComments().size(),
                s.getServiceDATE()
        );
    }

    public record detail (String serviceCODE,String serviceNAME, double serviceRATING, int commentCOUNT, String serviceDATE, List<commentVM> comments){
        public static detail from (service s){

            List<commentVM> recentCommentList = commentRepository.getRecentComments(s.getServiceCODE())
                    .stream().map(commentVM::from).toList();

            return new detail(
                    s.getServiceCODE(),
                    s.getServiceNAME(),
                    s.getServiceRATING(),
                    s.getComments().size(),
                    s.getServiceDATE(),
                    recentCommentList
            );
        }
    }
}
