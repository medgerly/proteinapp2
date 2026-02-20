import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["description", "button", "status"]
  static values = { url: String }

  async estimate() {
    const description = this.descriptionTarget.value.trim()
    if (!description) return

    this.buttonTarget.disabled = true
    this.buttonTarget.textContent = "Estimating..."
    this.statusTarget.classList.remove("hidden")
    this.statusTarget.textContent = "Analyzing meal..."

    try {
      const token = document.querySelector('meta[name="csrf-token"]').content
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token
        },
        body: JSON.stringify({ description })
      })

      const data = await response.json()

      if (data.error) {
        this.statusTarget.textContent = `Error: ${data.error}`
        return
      }

      // Fill in the form fields
      if (data.meal_name) this.setField("meal_meal_name", data.meal_name)
      if (data.protein != null) this.setField("meal_protein", data.protein)
      if (data.carbs != null) this.setField("meal_carbs", data.carbs)
      if (data.fat != null) this.setField("meal_fat", data.fat)
      if (data.calories != null) this.setField("meal_calories", Math.round(data.calories))

      this.statusTarget.textContent = "✓ Fields filled! Review and adjust as needed."
      this.statusTarget.classList.remove("text-indigo-400")
      this.statusTarget.classList.add("text-green-600")
    } catch (err) {
      this.statusTarget.textContent = `Failed: ${err.message}`
    } finally {
      this.buttonTarget.disabled = false
      this.buttonTarget.textContent = "Estimate"
    }
  }

  setField(id, value) {
    const el = document.getElementById(id)
    if (el) el.value = value
  }
}
