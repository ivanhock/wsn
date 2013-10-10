require 'test_helper'

class DispositivosControllerTest < ActionController::TestCase
  setup do
    @dispositivo = dispositivos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dispositivos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dispositivo" do
    assert_difference('Dispositivo.count') do
      post :create, :dispositivo => { :descripcion => @dispositivo.descripcion, :identificador => @dispositivo.identificador, :mac => @dispositivo.mac, :nombre => @dispositivo.nombre, :software_ejecutando => @dispositivo.software_ejecutando, :tipo => @dispositivo.tipo, :ultima_comunicacion => @dispositivo.ultima_comunicacion }
    end

    assert_redirected_to dispositivo_path(assigns(:dispositivo))
  end

  test "should show dispositivo" do
    get :show, :id => @dispositivo
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @dispositivo
    assert_response :success
  end

  test "should update dispositivo" do
    put :update, :id => @dispositivo, :dispositivo => { :descripcion => @dispositivo.descripcion, :identificador => @dispositivo.identificador, :mac => @dispositivo.mac, :nombre => @dispositivo.nombre, :software_ejecutando => @dispositivo.software_ejecutando, :tipo => @dispositivo.tipo, :ultima_comunicacion => @dispositivo.ultima_comunicacion }
    assert_redirected_to dispositivo_path(assigns(:dispositivo))
  end

  test "should destroy dispositivo" do
    assert_difference('Dispositivo.count', -1) do
      delete :destroy, :id => @dispositivo
    end

    assert_redirected_to dispositivos_path
  end
end
