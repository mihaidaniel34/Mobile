package com.example.testapp

 import android.os.Bundle
 import android.text.InputType
 import android.view.LayoutInflater
 import android.view.View
 import android.view.ViewGroup
 import android.widget.ArrayAdapter
 import android.widget.AutoCompleteTextView
 import androidx.fragment.app.Fragment
 import androidx.navigation.fragment.findNavController
 import com.example.testapp.Repository.Repository
 import com.example.testapp.databinding.FragmentSecondBinding
 import com.google.android.material.datepicker.MaterialDatePicker
 import com.google.android.material.slider.Slider
 import com.google.android.material.snackbar.Snackbar
 import com.google.android.material.textfield.MaterialAutoCompleteTextView
 import com.google.android.material.textfield.TextInputEditText
 import java.text.SimpleDateFormat
 import java.util.*

/**
 * A simple [Fragment] subclass as the second destination in the navigation.
 */
open class AddSeries : Fragment() {

    private var _binding: FragmentSecondBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!


    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {

        _binding = FragmentSecondBinding.inflate(inflater, container, false)
        activity?.actionBar?.title = "Title"
        return binding.root

    }
    protected val outputDateFormat = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault()).apply {
        timeZone = TimeZone.getTimeZone("UTC")
    }

    protected open fun initialize(view: View) {
        val releaseDate = view.findViewById<TextInputEditText>(R.id.release_date)
        val statuses = view.findViewById<MaterialAutoCompleteTextView>(R.id.statuses)
        initDatePicker(releaseDate)
        initStatuses(statuses)


        binding.button2.setOnClickListener {
            findNavController().navigate(R.id.action_SecondFragment_to_FirstFragment)
        }
        binding.button.setOnClickListener{
            val titleView = view.findViewById<TextInputEditText>(R.id.title)
            val noSeasonsView = view.findViewById<TextInputEditText>(R.id.no_seasons)
            val noEpisodesView = view.findViewById<TextInputEditText>(R.id.no_episodes)
            val ratingView = view.findViewById<Slider>(R.id.slider)
            if (validateViews(titleView, releaseDate, noSeasonsView, noEpisodesView, statuses, ratingView)) {
                Repository.addSeries(titleView.text.toString(), SimpleDateFormat("dd/MM/yyyy").parse(releaseDate.text.toString())!!, noSeasonsView.text.toString().toInt(),
                noEpisodesView.text.toString().toInt(), statuses.text.toString(), ratingView.value.toInt())
                Snackbar.make(view, "TV Series successfully added!", Snackbar.LENGTH_SHORT).show()
            }


        }
    }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initialize(view)

    }

    protected fun initStatuses(statuses: MaterialAutoCompleteTextView?) {
        statuses!!.setText("To watch")
        val items = listOf("Watching", "To watch", "Finished")
        val adapter = ArrayAdapter(
            requireContext(),
            androidx.appcompat.R.layout.select_dialog_item_material,
            items
        )
        (statuses as? AutoCompleteTextView)?.setAdapter(adapter)
    }

    protected fun initDatePicker(releaseDate: TextInputEditText) {
        releaseDate.inputType = InputType.TYPE_NULL

        releaseDate.setOnClickListener {
            val datePicker =
                MaterialDatePicker.Builder.datePicker()
                    .setTitleText("Select date")
                    .setSelection(MaterialDatePicker.todayInUtcMilliseconds())
                    .build()
            datePicker.addOnPositiveButtonClickListener {
                releaseDate.setText(outputDateFormat.format(it))
            }
            datePicker.show(childFragmentManager, null)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    protected fun validateViews(
        title: TextInputEditText,
        releaseDate: TextInputEditText,
        noSeasonsView: TextInputEditText,
        noEpisodesView: TextInputEditText,
        statuses: MaterialAutoCompleteTextView,
        slider: Slider
    ) : Boolean{
        var errorFound = false
        if (title.text.toString().isEmpty()) {
            title.error = "Required"
            errorFound = true
        }
        if (releaseDate.text.toString().isEmpty()) {
            releaseDate.error = "Required"
            errorFound = true
        }
        if (noSeasonsView.text.toString().isEmpty()) {
            noSeasonsView.error = "Required"
            errorFound = true
        }
        if (noEpisodesView.text.toString().isEmpty()) {
            noEpisodesView.error = "Required"
            errorFound = true
        }
        if (statuses.text.toString().isEmpty()) {
            statuses.error = "Required"
            errorFound = true
        }
        return !errorFound
    }

}