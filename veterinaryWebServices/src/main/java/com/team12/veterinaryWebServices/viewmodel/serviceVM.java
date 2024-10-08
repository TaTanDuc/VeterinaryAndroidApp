package com.team12.veterinaryWebServices.viewmodel;


import com.team12.veterinaryWebServices.model.comment;
import com.team12.veterinaryWebServices.model.service;

import java.util.List;

public record serviceVM (String serviceCODE, String serviceNAME, double serviceRATING, int commentCOUNT, String serviceDATE){

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
            return new detail(
                    s.getServiceCODE(),
                    s.getServiceNAME(),
                    s.getServiceRATING(),
                    s.getComments().size(),
                    s.getServiceDATE(),
                    s.getComments().stream().map(commentVM::from).toList()
            );
        }
    }
}
