class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]

  # GET /users
  def index
    begin
      users = User.all
      raise 'No user found' unless users.present?
      render :json => {users: ActiveModel::ArraySerializer.new(events, each_serializer: UserSerializer), :code => 200}, status: :ok
    rescue Exception => e
      logger.error {"Error while populating list of users. ErrorMessage: #{e.message}, Params: #{params.inspect}"}
      render json: {error: e.message, code: 500}
    end
  end

  def get_owner_list
    begin
      users = User.where(:is_admin => true)
      raise 'No user found' unless users.present?
      render :json => {owners: ActiveModel::ArraySerializer.new(events, each_serializer: UserSerializer), :code => 200}, status: :ok
    rescue Exception => e
      logger.error {"Error while populating list of admin users. ErrorMessage: #{e.message}, Params: #{params.inspect}"}
      render json: {error: e.message, code: 500}
    end
  end

  # GET /users/1
  def show
    begin
      raise 'User not found' unless @user.present?
      render json: UserSerializer.new(@user).attributes.merge!(code: 200, status: :ok)
    rescue Exception => e
      logger.error {"Error while showing details of an user. ErrorMessage: #{e.message}, Params: #{params.inspect}"}
      render json: {error: e.message, code: 500}
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserSerializer.new(@user).attributes.merge!(code: 200, status: :created)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    raise 'User not found' unless @user.present?
    if @user.update(user_params)
      render json: UserSerializer.new(@user).attributes.merge!(code: 200, status: :updated)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :is_admin)
    end
end
