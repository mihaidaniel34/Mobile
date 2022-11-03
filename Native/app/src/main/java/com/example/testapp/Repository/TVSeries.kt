package com.example.testapp.Repository

import java.util.Date

data class TVSeries(val id: Int, var title: String, var releaseDate: Date, var noSeasons: Int, var noEpisodes: Int, var status: String, var rating: Int) : java.io.Serializable