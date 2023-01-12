package mobile.server.Service;

import mobile.server.Model.TVSeries;
import mobile.server.Repository.TVSeriesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TVSeriesService implements ITVSeriesService {

    @Autowired
    private TVSeriesRepository tvSeriesRepository;

    @Override
    public List<TVSeries> getAll() {
        return tvSeriesRepository.findAll();
    }

    @Override
    public TVSeries addTVSeries(TVSeries tvSeries) {
        return tvSeriesRepository.save(tvSeries);
    }

    @Override
    public void deleteTVSeries(Long id) {
        tvSeriesRepository.findById(id).ifPresentOrElse(tvSeries -> tvSeriesRepository.deleteById(id), () -> {
                    throw new RuntimeException("TVSeries not found!");
                }
        );
    }

    @Override
    @Transactional
    public void updateTVSeries(TVSeries tvSeries) {
        tvSeriesRepository.findById(tvSeries.getId()).ifPresentOrElse(t -> {
            t.setTitle(tvSeries.getTitle());
            t.setNoSeasons(tvSeries.getNoSeasons());
            t.setNoEpisodes(tvSeries.getNoEpisodes());
            t.setReleaseDate(tvSeries.getReleaseDate());
            t.setRating(tvSeries.getRating());
            t.setStatus(tvSeries.getStatus());
        }, () -> {
            throw new RuntimeException("TVSeries not found!");
        });
    }
}
