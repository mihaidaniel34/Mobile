package com.example.testapp

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.example.testapp.Repository.Repository
import com.example.testapp.databinding.FragmentEditSeriesBinding
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.slider.RangeSlider
import com.google.android.material.slider.Slider
import com.google.android.material.snackbar.Snackbar
import com.google.android.material.textfield.MaterialAutoCompleteTextView
import com.google.android.material.textfield.TextInputEditText
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*

/**
 * A simple [Fragment] subclass as the second destination in the navigation.
 */
class EditSeries : AddSeries() {

    private var _binding: FragmentEditSeriesBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        _binding = FragmentEditSeriesBinding.inflate(inflater, container, false)
        activity?.actionBar?.title = "Title"
        return binding.root

    }

    override fun initialize(view: View){
        val seriesId = arguments?.getInt("id")
        val releaseDate = view.findViewById<TextInputEditText>(R.id.release_date)
        val statuses = view.findViewById<MaterialAutoCompleteTextView>(R.id.statuses)
        if (seriesId != null) {
            val tvSeries = Repository.getById(seriesId)
            val titleView = view.findViewById<TextInputEditText>(R.id.title)
            titleView.setText(tvSeries.title)
            releaseDate.setText(SimpleDateFormat("dd/MM/yyyy").format(tvSeries.releaseDate))

            val noSeasonsView = view.findViewById<TextInputEditText>(R.id.no_seasons)
            noSeasonsView.setText(tvSeries.noSeasons.toString())
            val noEpisodesView = view.findViewById<TextInputEditText>(R.id.no_episodes)
            noEpisodesView.setText(tvSeries.noEpisodes.toString())
            statuses.setText(tvSeries.status)
            val ratingView = view.findViewById<Slider>(R.id.slider)
            ratingView.value = tvSeries.rating.toFloat()

            binding.button2.setOnClickListener {
                MaterialAlertDialogBuilder(context!!).setTitle("Confirmation").setMessage("Are you sure you want to delete this TV Series?")
                    .setNeutralButton("Cancel"){_, _ ->}
                    .setPositiveButton("Yes"){_, _ ->
                        Repository.deleteSeries(seriesId)
                        findNavController().navigate(R.id.action_EditSeries_to_FirstFragment)
                    }
                    .show()

            }
            binding.button.setOnClickListener{
                if (validateViews(titleView, releaseDate, noSeasonsView, noEpisodesView, statuses, ratingView)){
                    MaterialAlertDialogBuilder(context!!).setTitle("Confirmation").setMessage("Are you sure you want to save this TV Series?")
                        .setNeutralButton("Cancel"){_, _ ->}
                        .setPositiveButton("Yes"){_, _ ->
                            Repository.updateSeries(seriesId, titleView.text.toString(), SimpleDateFormat("dd/MM/yyyy").parse(releaseDate.text.toString())!!, noSeasonsView.text.toString().toInt(),
                                noEpisodesView.text.toString().toInt(), statuses.text.toString(), ratingView.value.toInt())
                            Snackbar.make(view, "TV Series successfully updated!", Snackbar.LENGTH_SHORT).show()
                        }
                        .show()
                }
            }
        }
        initDatePicker(releaseDate)
        initStatuses(statuses)


    }

}