package mobile.server.Model;

import jakarta.persistence.*;
import lombok.*;

import java.util.Objects;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@ToString
public class TVSeries {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String title;
    private String releaseDate;
    private Integer noSeasons;
    private Integer noEpisodes;
    private String status;
    private Integer rating;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TVSeries tvSeries = (TVSeries) o;
        return Objects.equals(id, tvSeries.id);
    }
}
