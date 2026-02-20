SimpleForm.setup do |config|
  config.wrappers :default, class: "mb-4" do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: "block text-sm font-medium text-gray-700 mb-1"
    b.use :input, class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm
                          focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm
                          border px-3 py-2",
                  error_class: "border-red-500"
    b.use :full_error, wrap_with: { tag: :p, class: "mt-1 text-sm text-red-600" }
    b.use :hint, wrap_with: { tag: :p, class: "mt-1 text-sm text-gray-500" }
  end

  config.default_wrapper = :default
  config.button_class = "btn"
  config.label_text = ->(label, required, _) { "#{label}#{required ? ' *' : ''}" }
  config.generate_additional_classes_for = []
  config.browser_validations = false
  config.boolean_style = :nested
  config.boolean_label_class = "checkbox"
end
