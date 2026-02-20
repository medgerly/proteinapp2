class AiMealEstimator
  SYSTEM_PROMPT = <<~PROMPT
    You are a nutrition expert. When given a meal description, respond ONLY with a valid JSON object
    containing estimated macro nutrients. Use these exact keys:
    {
      "meal_name": "Clean meal name",
      "protein": <float grams>,
      "carbs": <float grams>,
      "fat": <float grams>,
      "calories": <float kcal>
    }
    Base estimates on standard serving sizes. Round to 1 decimal place.
    Respond with ONLY the JSON, no explanation, no markdown.
  PROMPT

  def self.call(description)
    new(description).call
  end

  def initialize(description)
    @description = description.to_s.strip
  end

  def call
    return error_response("No description provided") if @description.blank?

    api_key = ENV["ANTHROPIC_API_KEY"]
    return mock_response if api_key.blank?

    response = HTTP.auth("x-api-key #{api_key}")
      .headers(
        "anthropic-version" => "2023-06-01",
        "content-type" => "application/json"
      )
      .post(
        "https://api.anthropic.com/v1/messages",
        json: {
          model: "claude-haiku-4-5-20251001",
          max_tokens: 256,
          system: SYSTEM_PROMPT,
          messages: [{ role: "user", content: @description }]
        }
      )

    if response.status.success?
      text = JSON.parse(response.body.to_s).dig("content", 0, "text").to_s
      JSON.parse(text)
    else
      error_response("API error: #{response.status}")
    end
  rescue JSON::ParserError
    error_response("Could not parse response")
  rescue => e
    error_response(e.message)
  end

  private

  def mock_response
    # Sensible default when no API key is set (development fallback)
    {
      "meal_name" => @description.split.first(3).join(" ").capitalize,
      "protein" => 25.0,
      "carbs" => 40.0,
      "fat" => 10.0,
      "calories" => 350.0
    }
  end

  def error_response(msg)
    { "error" => msg }
  end
end
