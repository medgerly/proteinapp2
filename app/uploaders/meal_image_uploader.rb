class MealImageUploader < CarrierWave::Uploader::Base
  if Rails.env.production?
    include Cloudinary::CarrierWave
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    "/images/meal_placeholder.png"
  end

  def extension_allowlist
    %w[jpg jpeg gif png webp]
  end

  def size_range
    1..10.megabytes
  end
end
