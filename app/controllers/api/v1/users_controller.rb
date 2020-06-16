  class Api::V1::UsersController < Api::V1::BaseController
    before_action :authenticate_user!, except: [:reset_password]
    before_action :load_resource, except: [:index, :create, :update_status, :reset_password]

    def index
      authorize current_user
      params[:page] ||= 1
      if current_user.admin?
          @users = User.all
            .where(query_conditions)
            .page(params[:page])
            .per(10)
      elsif current_user.manager?
        enterprises = []
        if params.has_key?(:enterprise_id) && !params[:enterprise_id].nil?
          if current_user.enterprises.where(id: params[:enterprise_id]).any?
            enterprises << params[:enterprise_id]
          else
            render json: { error: 'Você não tem permissão para acessar estes registros' }, status: :unprocessable_entity
          end
        else
          enterprises << current_user.enterprises.pluck(:id)
        end
        @users = User.employee
          .where(enterprise_id: enterprises)
          .page(params[:page])
          .per(10)
      elsif current_user.employee?
        @users = User.employee
          .where(enterprise_id: current_user.enterprise_id)
          .page(params[:page])
          .per(10)
      end
    end

    def create
      authorize current_user
      @user = User.new(sign_up_params)
      if current_user.master? @user
        @user.save!
        render status: :created
      else
        render json: { error: 'Você não tem permissão para criar este registro' }, status: :forbidden
      end
    end

    def show
      authorize current_user
      unless current_user.have_access? @user
        render json: { error: 'Você não tem permissão para exibir este registro' }, status: :forbidden
      end
    end

    def update
      authorize current_user
      if current_user.have_control? @user
        @user.update!(update_params)
      else
        render json: { error: 'Você não tem permissão para alterar este registro' }, status: :forbidden
      end
    end

    def update_status
      authorize current_user
      require_parameters([:users, :status])
      users = User.where(id: params[:users])
      users.each do |user| 
        user[:status] = params[:status]
        user.save!
      end
    end

    def destroy
      authorize current_user
      if current_user.master? @user
        @user.destroy!
      else
        render json: { error: 'Você não tem permissão para excluir este registro' }, status: :forbidden
      end
    end

    def password
      if current_user.self? @user
        @user.update_with_password!(password_params)
      else
        render json: { error: 'Você não tem permissão para alterar este registro' }, status: :forbidden
      end
    end

    private

      def query_conditions
        conditions = {}
        if params[:role] && !params[:role].nil?
          conditions[:role] = params[:role]
        end
        if params[:enterpriseId] && !params[:enterpriseId].nil?
          conditions[:enterprise_id] = params[:enterpriseId]
        end
      end

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

