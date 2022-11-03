package com.example.testapp.Repository

import java.util.*
import kotlin.collections.ArrayList

object Repository {
    var data: ArrayList<TVSeries> = ArrayList()


    init {
        val tvSeries1 = TVSeries(1,"House of the Dragon", Date(), 1, 8, "Watching", 0)
        val tvSeries2 = TVSeries(2,"Breaking Bad", Date(), 6, 40, "Finished", 10)
        val tvSeries3 = TVSeries(3, "Rick and Morty", Date(), 6, 50, "Finished", 9)
        data.add(tvSeries1)
        data.add(tvSeries2)
        data.add(tvSeries3)
    }

    fun getById(id: Int)  : TVSeries{
        return data.first{it.id == id}
    }

    fun deleteSeries(id : Int){
        data.removeIf{it.id == id}
    }
    fun getNewId() : Int{
        val max = data.maxOfOrNull { it.id }
        return if (max != null) max + 1 else 1
    }

    fun addSeries(
        title: String,
        date: Date,
        noSeasons: Int,
        noEpisodes: Int,
        status: String,
        rating: Int
    ) {
        val series = TVSeries(getNewId(), title, date, noSeasons, noEpisodes, status, rating)
        data.add(series)
    }
    fun updateSeries(
        id: Int,
        title: String,
        date: Date,
        noSeasons: Int,
        noEpisodes: Int,
        status: String,
        rating: Int
    ){

        val original = getById(id)
        original.title = title
        original.releaseDate = date
        original.noSeasons = noSeasons
        original.noEpisodes = noEpisodes
        original.status = status
        original.rating = rating
    }

    fun findByString(filter : String): ArrayList<TVSeries> {
        return data.filter { it.title.contains(filter, true) }.toCollection(kotlin.collections.ArrayList())
    }
}
