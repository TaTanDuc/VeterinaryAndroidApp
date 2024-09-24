package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.comment;
import com.team12.veterinaryWebServices.model.service;
import com.team12.veterinaryWebServices.repository.commentRepository;
import com.team12.veterinaryWebServices.repository.serviceRepository;
import com.team12.veterinaryWebServices.viewmodel.commentVM;
import com.team12.veterinaryWebServices.viewmodel.serviceVM;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.aop.AopInvocationException;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.scheduling.annotation.Schedules;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class serviceServices {

    private final serviceRepository serviceRepository;
    private final commentRepository commentRepository;

    public List<serviceVM> getAllServices(){
        return serviceRepository.findAll()
                .stream()
                .map(serviceVM::from)
                .toList();
    }

    public List<commentVM> getServiceComments(String serviceCODE){
        return commentRepository.getServiceComments(serviceCODE)
                .stream()
                .map(commentVM::from)
                .toList();
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
