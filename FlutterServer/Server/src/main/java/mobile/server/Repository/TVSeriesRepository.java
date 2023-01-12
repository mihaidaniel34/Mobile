package mobile.server.Repository;

import mobile.server.Model.TVSeries;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TVSeriesRepository extends JpaRepository<TVSeries, Long> {
}
