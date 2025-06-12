# gtrendshealth 1.0.0

This version is considered feature complete, as it handles queries as documented
by the restricted Google Trends For Health API.
Convenience functions for handling search data should be developed as separate
packages.

## Breaking changes

- API query function renamed from `getTimelinesForHealth` to `get_health_trends`.

- geo restriction parameter names simplified:
  + `country` instead of `geoRestriction.ountry`
  + `region` instead of `geoRestriction.region`
  + `dma` instead of `geoRestriction.dma`

## Major changes

- Added unit tests

## Minor changes

- Added API query examples and data use examples
- Improved API key handling
- Fixed unit test error tripped by automated R CMD Check


# gtrendshealth 0.1.0

* Document NEWS.
