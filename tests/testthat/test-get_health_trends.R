#------------------------------------------------------------------------------*
# test basic parameter requirements
#------------------------------------------------------------------------------*

test_that("requires parameter terms", {
  expect_error(
    get_health_trends(key = "aaa"),
    regexp = "terms"
  )
})

test_that("requires parameter resolution", {
  expect_error(
    get_health_trends(
      terms = "test",
      key = "aaa"
    ),
    regexp = "resolution"
  )
})

test_that("requires parameter start", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "year",
      key = "aaa"
    ),
    regexp = "start"
  )
})

test_that("requires parameter end", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "year",
      start = as.Date("2025-01-01"),
      key = "aaa"
    ),
    regexp = "end"
  )
})




#------------------------------------------------------------------------------*
# test parameter types and length
#------------------------------------------------------------------------------*

test_that("terms should be a character", {
  expect_error(
    get_health_trends(
      terms = 1,
      key = "aaa"
    ),
    regexp = "Terms should be characters."
  )
})

test_that("at least one term provided", {
  expect_error(
    get_health_trends(
      terms = character(0),
      key = "aaa"
    ),
    regexp = "at least one term"
  )
})

test_that("no more than 30 terms provided", {
  expect_error(
    get_health_trends(
      terms = rep("a", 31),
      key = "aaa"
    ),
    regexp = "at most 30 terms"
  )
})

test_that("no more than one resolution", {
  if(Sys.getenv("GOOGLE_TRENDS_FOR_HEALTH_API_KEY")!=""){
    expect_warning(
      tryCatch(
        get_health_trends(
          terms = "test",
          resolution = c("day", "month"),
          start = as.Date("2025-01-01"),
          end = as.Date("2025-01-01") + 1,
          key = "aaa"
        ),
        error = function(e) FALSE
      ),
      regexp = "resolutions, only the first will be used"
    )
  }
})

test_that("valid resolution", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "wrong",
      start = as.Date("2025-01-01"),
      end = as.Date("2025-01-01") + 1,
      key = "aaa"
    ),
    regexp = "must be one of"
  )
})

test_that("requires parameter start as date", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "year",
      start = "2025-01-01",
      key = "aaa"
    ),
    regexp = "must be a date object"
  )
})

test_that("requires parameter end as date", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "year",
      start = as.Date("2025-01-01"),
      end = "2025-01-01",
      key = "aaa"
    ),
    regexp = "must be a date object"
  )
})

test_that("end > start", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "year",
      start = as.Date("2025-01-01"),
      end = as.Date("2025-01-01"),
      key = "aaa"
    ),
    regexp = "must be before end"
  )
})

test_that("end < today", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "year",
      start = as.Date("2025-01-01"),
      end = Sys.Date(),
      key = "aaa"
    ),
    regexp = "must be before today"
  )
})

test_that("only one geo restriction", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "month",
      start = as.Date("2025-01-01"),
      end = as.Date("2025-01-01") + 1,
      country = "test",
      region = "test",
      key = "aaa"
    ),
    regexp = "Only one geographic restriction"
  )
})

test_that("invalid country geo restriction", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "month",
      start = as.Date("2025-01-01"),
      end = as.Date("2025-01-01") + 1,
      country = "test",
      key = "aaa"
    )
  )
})

test_that("invalid region geo restriction", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "month",
      start = as.Date("2025-01-01"),
      end = as.Date("2025-01-01") + 1,
      region = "test",
      key = "aaa"
    )
  )
})

test_that("invalid dma geo restriction", {
  expect_error(
    get_health_trends(
      terms = "test",
      resolution = "month",
      start = as.Date("2025-01-01"),
      end = as.Date("2025-01-01") + 1,
      dma = "test",
      key = "aaa"
    )
  )
})




#------------------------------------------------------------------------------*
# test expected data
#------------------------------------------------------------------------------*
# a valid API key is required for all these tests
#------------------------------------------------------------------------------*

valid_key <- tryCatch(
  nrow(
    get_health_trends(
      terms = "test",
      resolution = "month",
      start = as.Date("2025-01-01"),
      end = as.Date("2025-01-02")
    )
  ) == 1,
  error = function(e) FALSE
)

test_that("no geo restriction", {
  if(valid_key){
    expect_s3_class(
      get_health_trends(
        terms = "test",
        resolution = "month",
        start = as.Date("2025-01-01"),
        end = as.Date("2025-01-02")
      ),
      class = "data.frame"
    )
  }
})

test_that("some geo restriction", {
  if(valid_key){
    expect_s3_class(
      get_health_trends(
        terms = "test",
        resolution = "month",
        start = as.Date("2025-01-01"),
        end = as.Date("2025-01-02"),
        country = "US"
      ),
      class = "data.frame"
    )
  }
})

test_that("gets daily data", {
  if(valid_key){
    expect_equal(
      nrow(
        get_health_trends(
          terms = "test",
          resolution = "day",
          start = as.Date("2024-01-01"),
          end = as.Date("2024-01-31")
        )
      ),
      expected = 31
    )
  }
})

test_that("gets weekly data", {
  if(valid_key){
    expect_gt(
      nrow(
        get_health_trends(
          terms = "test",
          resolution = "week",
          start = as.Date("2024-01-01"),
          end = as.Date("2024-12-31")
        )
      ),
      expected = 50
    )
  }
})

test_that("gets montly data", {
  if(valid_key){
    expect_equal(
      nrow(
        get_health_trends(
          terms = "test",
          resolution = "month",
          start = as.Date("2024-01-01"),
          end = as.Date("2024-12-31")
        )
      ),
      expected = 12
    )
  }
})

test_that("gets yearly data", {
  if(valid_key){
    expect_equal(
      nrow(
        get_health_trends(
          terms = "test",
          resolution = "year",
          start = as.Date("2024-01-01"),
          end = as.Date("2024-12-31")
        )
      ),
      expected = 1
    )
  }
})

test_that("gets multiple terms", {
  if(valid_key){
    expect_equal(
      nrow(
        get_health_trends(
          terms = letters,
          resolution = "year",
          start = as.Date("2024-01-01"),
          end = as.Date("2024-12-31")
        )
      ),
      expected = length(letters)
    )
  }
})
