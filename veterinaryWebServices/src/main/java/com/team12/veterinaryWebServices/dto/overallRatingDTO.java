package com.team12.veterinaryWebServices.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class overallRatingDTO {
    private int FiveStar;
    private int FourStar;
    private int ThreeStar;
    private int TwoStar;
    private int OneStar;
}
