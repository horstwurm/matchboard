require 'test_helper'

class ResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @result = results(:one)
  end

  test "should get index" do
    get results_url
    assert_response :success
  end

  test "should get new" do
    get new_result_url
    assert_response :success
  end

  test "should create result" do
    assert_difference('Result.count') do
      post results_url, params: { result: { breakball: @result.breakball, gameG: @result.gameG, gameH: @result.gameH, game_id: @result.game_id, matchball: @result.matchball, set1G: @result.set1G, set1H: @result.set1H, set2G: @result.set2G, set2H: @result.set2H, set3G: @result.set3G, set3H: @result.set3H, set4G: @result.set4G, set4H: @result.set4H, set5G: @result.set5G, set5H: @result.set5H, setball: @result.setball } }
    end

    assert_redirected_to result_url(Result.last)
  end

  test "should show result" do
    get result_url(@result)
    assert_response :success
  end

  test "should get edit" do
    get edit_result_url(@result)
    assert_response :success
  end

  test "should update result" do
    patch result_url(@result), params: { result: { breakball: @result.breakball, gameG: @result.gameG, gameH: @result.gameH, game_id: @result.game_id, matchball: @result.matchball, set1G: @result.set1G, set1H: @result.set1H, set2G: @result.set2G, set2H: @result.set2H, set3G: @result.set3G, set3H: @result.set3H, set4G: @result.set4G, set4H: @result.set4H, set5G: @result.set5G, set5H: @result.set5H, setball: @result.setball } }
    assert_redirected_to result_url(@result)
  end

  test "should destroy result" do
    assert_difference('Result.count', -1) do
      delete result_url(@result)
    end

    assert_redirected_to results_url
  end
end
