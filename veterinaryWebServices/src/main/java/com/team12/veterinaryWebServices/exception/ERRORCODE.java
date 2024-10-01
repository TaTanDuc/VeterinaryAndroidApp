package com.team12.veterinaryWebServices.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

@Getter
public enum ERRORCODE {

    NO_SERVICE_IN_APPOINTMENT("There is no service in the appointment!", HttpStatus.BAD_REQUEST),
    USER_EXISTED("User already existed!", HttpStatus.BAD_REQUEST),
    USER_DOES_NOT_EXIST("User doesn't exist!", HttpStatus.BAD_REQUEST),
    PASSWORD_NOT_MATCH("User password isn't right!", HttpStatus.CONFLICT),
    PASS_WORD_CANT_NULL("Password can't be left blank!", HttpStatus.BAD_REQUEST),
    UNAUTHENTICATED("Unauthenticated!",HttpStatus.UNAUTHORIZED),
    APPOINTMENT_FULL("Appointment at that time is full!", HttpStatus.BAD_REQUEST),
    PET_DOES_NOT_EXIST("Pet doesn't exist!", HttpStatus.BAD_REQUEST),
    NOT_PET_OWNER("You are not the owner of this pet!", HttpStatus.UNAUTHORIZED),
    SERVICE_DOES_NOT_EXIST("Service doesn't exist!", HttpStatus.NOT_FOUND),
    NO_COMMENT("There is no comment here!", HttpStatus.NOT_FOUND),
    CART_DOES_NOT_EXIST("Cart doesn't exist!", HttpStatus.BAD_REQUEST),
    NOT_CART_OWNER("This is not your cart!", HttpStatus.CONFLICT),
    ITEM_OVER_STOCK("Your item quantity is over the stock limit!", HttpStatus.BAD_REQUEST),
    SOLD_OUT("Your item have been sold out!", HttpStatus.NOT_FOUND),
    NO_ITEM_FOUND("There is no item here!", HttpStatus.NOT_FOUND),
    NO_APPOINTMENT_FOUND("There is no appointment here!", HttpStatus.NOT_FOUND),
    NO_INVOICE_FOUND("There is no invoice here!", HttpStatus.NOT_FOUND),
    NO_PET_FOUND("There is no pet here!", HttpStatus.NOT_FOUND),
    NO_PET_DETAIL_FOUND("There is no pet's detail here!", HttpStatus.NOT_FOUND),
    NO_PROFILE_FOUND("There is no profile here!", HttpStatus.NOT_FOUND),
    NO_SERVICE_FOUND("There is no service here!", HttpStatus.NOT_FOUND),
    ;


    ERRORCODE(String message, HttpStatusCode statusCode){
        this.message = message;
        this.statusCode = statusCode;
    }

    private final String message;
    private final HttpStatusCode statusCode;
}
