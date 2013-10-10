require 'test_helper'

class ImagensControllerTest < ActionController::TestCase
  setup do
    @imagen = imagens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:imagens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create imagen" do
    assert_difference('Imagen.count') do
      post :create, imagen: { descripcion: @imagen.descripcion, imagen_1: @imagen.imagen_1, imagen_2: @imagen.imagen_2, imagen_p: @imagen.imagen_p }
    end

    assert_redirected_to imagen_path(assigns(:imagen))
  end

  test "should show imagen" do
    get :show, id: @imagen
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @imagen
    assert_response :success
  end

  test "should update imagen" do
    put :update, id: @imagen, imagen: { descripcion: @imagen.descripcion, imagen_1: @imagen.imagen_1, imagen_2: @imagen.imagen_2, imagen_p: @imagen.imagen_p }
    assert_redirected_to imagen_path(assigns(:imagen))
  end

  test "should destroy imagen" do
    assert_difference('Imagen.count', -1) do
      delete :destroy, id: @imagen
    end

    assert_redirected_to imagens_path
  end
end
