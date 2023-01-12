package mobile.server.Service;

import mobile.server.Model.TVSeries;

import java.util.List;

public interface ITVSeriesService {
    List<TVSeries> getAll();

    TVSeries addTVSeries(TVSeries tvSeries);

    void deleteTVSeries(Long id);

    void updateTVSeries(TVSeries tvSeries);

}
