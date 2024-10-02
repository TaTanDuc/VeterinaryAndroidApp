package com.team12.veterinaryWebServices.dto;

import com.team12.veterinaryWebServices.model.storage;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class cartDTO {
    private Long profileID;
    private Long cartID;
    private List<storage> items;
}
