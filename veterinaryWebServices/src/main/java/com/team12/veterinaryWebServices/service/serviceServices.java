package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.service;
import com.team12.veterinaryWebServices.repository.serviceRepository;
import com.team12.veterinaryWebServices.viewmodel.serviceVM;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class serviceServices {

    private final serviceRepository serviceRepository;

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

    @Scheduled(fixedRate = 60000)
    private void calculateServiceRating() {
        List<service> all = serviceRepository.findAll();

        for (service s : all){
            s.setServiceRATING(serviceRepository.averageServiceRating(s.getServiceCODE()));
            serviceRepository.save(s);
        }
    }

}
