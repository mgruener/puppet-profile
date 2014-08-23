class profile::radiusserver {
  include freeradius
  Freeradius::Client <| tag == 'radius_client' |>
}
