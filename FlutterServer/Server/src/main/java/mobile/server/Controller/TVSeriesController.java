package mobile.server.Controller;

import mobile.server.Dto.Message;
import mobile.server.Dto.TVSeriesDTO;
import mobile.server.Model.TVSeries;
import mobile.server.Service.ITVSeriesService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class TVSeriesController {

    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    @Autowired
    private ITVSeriesService tvSeriesService;

    Logger logger = LoggerFactory.getLogger(TVSeriesController.class);

    @GetMapping("/series")
    public ResponseEntity<List<TVSeries>> getAllSeries() {
        logger.info("Getting all series");
        return new ResponseEntity<>(tvSeriesService.getAll(), HttpStatus.OK);
    }

    @PostMapping("/series/{appId}")
    public ResponseEntity<TVSeries> addTVSeries(@RequestBody TVSeriesDTO tvSeriesDTO, @PathVariable String appId) {
        logger.info("Added new series " + tvSeriesDTO);
        TVSeries series = tvSeriesService.addTVSeries(tvSeriesDTO.toModel());
        simpMessagingTemplate.convertAndSend("/changes/listen", new Message(Message.Type.ADD, series, appId));
        return new ResponseEntity<>(series, HttpStatus.CREATED);
    }

    @DeleteMapping("/series/{id}&{appId}")
    public ResponseEntity<?> deleteTVSeries(@PathVariable Long id, @PathVariable String appId) {
        logger.info("Deleting series with id " + id);
        tvSeriesService.deleteTVSeries(id);
        simpMessagingTemplate.convertAndSend("/changes/listen", new Message(Message.Type.DELETE, id, appId));
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("/series/{appId}")
    public ResponseEntity<?> updateTVSeries(@RequestBody TVSeriesDTO tvSeriesDTO, @PathVariable String appId) {
        logger.info("Updating series " + tvSeriesDTO);
        tvSeriesService.updateTVSeries(tvSeriesDTO.toModel());
        simpMessagingTemplate.convertAndSend("/changes/listen", new Message(Message.Type.UPDATE, tvSeriesDTO, appId));
        return new ResponseEntity<>(HttpStatus.OK);
    }


    @GetMapping("/hello/{name}")
    public String hello(@PathVariable String name) {
        simpMessagingTemplate.convertAndSend("/changes/listen", "Hello");
        return "Hello " + name;
    }

}
