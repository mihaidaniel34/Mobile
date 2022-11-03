package com.example.testapp

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.constraintlayout.motion.widget.OnSwipe
import androidx.core.content.ContextCompat
import androidx.core.os.bundleOf
import androidx.core.view.ViewCompat
import androidx.core.view.isGone
import androidx.core.view.isInvisible
import androidx.core.view.isVisible
import androidx.navigation.Navigation
import androidx.navigation.findNavController
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.RecyclerView
import com.example.testapp.Repository.Repository
import com.example.testapp.Repository.TVSeries
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.shape.MaterialShapeDrawable
import com.google.android.material.shape.RelativeCornerSize
import com.google.android.material.shape.RoundedCornerTreatment
import com.google.android.material.shape.ShapeAppearanceModel

class SeriesAdapter(var data : ArrayList<TVSeries>) : RecyclerView.Adapter<SeriesAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        return ViewHolder.from(parent, this)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = data[position]
        holder.bind(item)
    }

    override fun getItemCount(): Int {
        return data.size
    }

    class ViewHolder(itemView : View, var adapter: SeriesAdapter) : RecyclerView.ViewHolder(itemView) {

        val title: TextView = itemView.findViewById(R.id.series_title)
        val status: TextView = itemView.findViewById(R.id.series_status)
//        val image: ImageView = itemView.findViewById(R.id.series_image)
        val rating: TextView = itemView.findViewById(R.id.rating)
        val image : TextView = itemView.findViewById(R.id.series_image)

        fun bind(item: TVSeries) {
            val res = itemView.context.resources
            title.text = item.title
            status.text = item.status
            rating.text = item.rating.toString() + "/10"
            // image.setImageIcon()
            image.text = item.title[0].toString()
            val shape = ShapeAppearanceModel().toBuilder().setAllCorners(RoundedCornerTreatment()).setAllCornerSizes(RelativeCornerSize(0.5f)).build()
            val drawable = MaterialShapeDrawable(shape)
            drawable.fillColor = ContextCompat.getColorStateList(itemView.context, com.google.android.material.R.color.m3_default_color_primary_text)
            ViewCompat.setBackground(image, drawable)
            itemView.setOnClickListener{
                val bundle = bundleOf("id" to item.id)
                Navigation.findNavController(itemView).navigate(R.id.action_EditSeries, bundle)
            }
            itemView.setOnLongClickListener{
                MaterialAlertDialogBuilder(itemView.context).setTitle("Confirmation").setMessage("Are you sure you want to delete this TV Series?")
                    .setNeutralButton("Cancel"){_, _ ->}
                    .setPositiveButton("Yes"){_, _ ->
                        Repository.deleteSeries(item.id)
                        adapter.notifyDataSetChanged()
                    }
                    .show()

                true
            }
            }


        companion object {
            fun from(parent: ViewGroup, adapter: SeriesAdapter): ViewHolder {
                val layoutInflater = LayoutInflater.from(parent.context)
                val view = layoutInflater
                    .inflate(R.layout.item_layout, parent, false)
                return ViewHolder(view, adapter)
            }
        }

    }

}

