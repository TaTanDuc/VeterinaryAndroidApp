package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.commentDTO;
import com.team12.veterinaryWebServices.dto.overallRatingDTO;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.comment;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.model.service;
import com.team12.veterinaryWebServices.repository.commentRepository;
import com.team12.veterinaryWebServices.repository.profileRepository;
import com.team12.veterinaryWebServices.repository.serviceRepository;
import com.team12.veterinaryWebServices.viewmodel.commentVM;
import com.team12.veterinaryWebServices.viewmodel.serviceVM;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class serviceServices {

    private final serviceRepository serviceRepository;
    private final commentRepository commentRepository;
    private final profileRepository profileRepository;

    public Object getAllServices(){
        List<service> list = serviceRepository.findAll();

        if (list.isEmpty())
            return new appException(ERRORCODE.NO_SERVICE_FOUND);
        return list.stream().map(serviceVM::from).toList();
    }

    public Object getServiceDetail(String serviceCODE){
        service service = serviceRepository.getService(serviceCODE);

        if (service == null)
            return new appException(ERRORCODE.NO_SERVICE_FOUND);

        return serviceVM.detail.from(service);
    }

    public Object getServiceComments(String serviceCODE){
        List<comment> comments = commentRepository.getComments(serviceCODE);

        if (comments.isEmpty())
            return new appException(ERRORCODE.NO_COMMENT);

        return comments.stream().map(commentVM::from).toList();
    }

    public Object getOverallRating(String serviceCODE){
        List<comment> comments = commentRepository.getComments(serviceCODE);

        if (comments.isEmpty())
            return new appException(ERRORCODE.NO_COMMENT);

        overallRatingDTO r = new overallRatingDTO();

        Map<Integer, Long> starCounts = comments.stream()
                .collect(Collectors.groupingBy(comment::getCommentRATING, Collectors.counting()));

        return starCounts;
    }

    public Object addComment(commentDTO request){
        service s = serviceRepository.getService(request.getServiceCODE());
        if(s == null)
            return new appException(ERRORCODE.NO_SERVICE_FOUND);

        profile p = profileRepository.getProfileById(request.getUserID());
        if(p == null)
            return new appException(ERRORCODE.USER_DOES_NOT_EXIST);

        if(request.getRating() < 1 || request.getRating() > 5)
            return new appException(ERRORCODE.RATING_ERROR);

        if(request.getContent().length() < 20 || request.getContent().length() > 200)
            return new appException(ERRORCODE.CONTENT_ERROR);

        comment c = new comment();

        c.setProfile(p);
        c.setService(s);
        c.setCommentRATING(request.getRating());
        c.setCONTENT(request.getContent());
        c.setCommentDATE(new Date());

        commentRepository.save(c);

        return new appException("Comment added successfully!");
    }

    @Scheduled(fixedRate = 60000)
    private void calculateServiceRating() {
        List<service> all = serviceRepository.findAll();

        for (service s : all){
            s.setServiceRATING(serviceRepository.averageServiceRating(s.getServiceCODE()));
            serviceRepository.save(s);
        }
    }
}
