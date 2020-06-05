  class Api::V1::UsersController < Api::V1::BaseController
    before_action :authenticate_user!, except: [:reset_password]
    before_action :load_resource, except: [:create, :reset_password]

    # CRUDs
    def create
      @user = User.new(sign_up_params)
      authorize current_user
      if current_user.check_permission(@user)
        @user.save!
        render json: @user, status: :created
      else
        render json: { error: 'Você não tem permissão para criar este registro' }, status: :forbidden
      end
    end

    def update
      authorize current_user
      if current_user.check_permission(@user)
        @user.update!(update_params)
        render json: @user
      else
        render json: { error: 'Você não tem permissão para alterar este registro' }, status: :forbidden
      end
    end

    def show
      authorize @user
      render json: @user
    end

    # Custom actions
    def password
      authorize @user
      @user.update_with_password!(password_params)
    end

    def reset_password
      params.require(:email)
      User.reset_password(params[:email])
      # No Content
    end

    def register_device
      require_parameters([:device_id, :device_os])
      authorize @user
      current_user.register_device(request.headers["client"], params[:device_id], params[:device_os])
      # No Content
    end

    ###
    private

      def sign_up_params
        if (params[:role] == 'employee' or params[:role] == 2)
          require_parameters([:email, :password, :name, :phone, :role, :enterprise_id])
          params.permit(:email, :password, :name, :phone, :role, :enterprise_id)
        else
          require_parameters([:email, :password, :name, :phone, :role])
          params.permit(:email, :password, :name, :phone, :role)
        end
      end

      def update_params
        params.permit(:email, :phone, :name)
      end

      def password_params
        require_parameters([:current_password, :password])
        params.permit(:current_password, :password, :password_confirmation)
      end


  end

