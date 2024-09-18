package com.team12.veterinaryWebServices.security.dto;

import com.team12.veterinaryWebServices.enums.ERRORCODE;

public class appException extends RuntimeException {

    public appException(ERRORCODE errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    private ERRORCODE errorCode;

    public ERRORCODE getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(ERRORCODE errorCode) {
        this.errorCode = errorCode;
    }
}