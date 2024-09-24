package com.team12.veterinaryWebServices.viewmodel;


import com.team12.veterinaryWebServices.model.service;

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
}
