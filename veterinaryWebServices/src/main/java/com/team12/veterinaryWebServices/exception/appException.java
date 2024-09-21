package com.team12.veterinaryWebServices.exception;

import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

import java.util.Objects;

@Getter
@Setter
public class appException extends RuntimeException{

    public appException(ERRORCODE errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    public appException(String customMessage){
        super(customMessage);
        this.customMessage = customMessage;
    }

    private String customMessage;

    private ERRORCODE errorCode;

    public HttpStatusCode getErrorCode() {
        if(errorCode != null)
            return errorCode.getStatusCode();
        return HttpStatus.OK;
    }
}
