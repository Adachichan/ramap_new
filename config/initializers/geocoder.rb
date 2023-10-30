Geocoder.configure(
  lookup: :google,
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ],
  api_key:  ENV['GEOCODING_API_KEY'] ,
  use_https: true
)