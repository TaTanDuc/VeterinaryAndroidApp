package com.team12.veterinaryWebServices.exception;

public class appException extends RuntimeException{
    public appException(ERRORCODE errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    public appException(String s){
    }

    private ERRORCODE errorCode;

    public ERRORCODE getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(ERRORCODE errorCode) {
        this.errorCode = errorCode;
    }
}
