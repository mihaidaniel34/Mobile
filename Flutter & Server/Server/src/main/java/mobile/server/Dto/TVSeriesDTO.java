package mobile.server.Dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import mobile.server.Model.TVSeries;

@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class TVSeriesDTO {
    @JsonProperty("id")
    private Long id;

    @JsonProperty("title")
    private String title;

    @JsonProperty("releaseDate")
    private String releaseDate;

    @JsonProperty("noSeasons")
    private Integer noSeasons;

    @JsonProperty("noEpisodes")
    private Integer noEpisodes;

    @JsonProperty("status")
    private String status;

    @JsonProperty("rating")
    private Integer rating;

    public TVSeries toModel() {
        return TVSeries.builder()
                .id(id)
                .title(title)
                .releaseDate(releaseDate)
                .noSeasons(noSeasons)
                .noEpisodes(noEpisodes)
                .status(status)
                .rating(rating)
                .build();
    }

}
