class Api::V1::EnterprisesController < Api::V1::BaseController
    before_action :authenticate_user!
    before_action :load_resource, except: [:index, :create]

    def index
      authorize current_user
      params[:page] ||= 1
      if current_user.admin?
        @enterprises = Enterprise.all
          .page(params[:page])
          .per(10)
      elsif current_user.manager?
        @enterprises = Enterprise.all
          .where(user_id: current_user.id)
          .page(params[:page])
          .per(10)
      elsif current_user.employee?
        @enterprises = Enterprise.find(current_user.enterprise_id)
      end
    end

    def create
        authorize current_user
        @enterprise = Enterprise.new(create_params)
        if current_user.manager?
          @enterprise.manager_id = current_user.id
        end
        @enterprise.save!
        render status: :created
    end

    def show
      authorize current_user
      unless current_user.have_access_enterprise? @enterprise
        render json: { error: 'Você não tem permissão para exibir este registro' }, status: :forbidden
      end
    end

    def update
      authorize current_user
      if current_user.have_control_enterprise? @enterprise
        @enterprise.update!(update_params)
      else
        render json: { error: 'Você não tem permissão para alterar este registro' }, status: :forbidden
      end
    end

    def destroy
      authorize current_user
      if current_user.have_control_enterprise? @enterprise
        @enterprise.destroy!
      else
        render json: { error: 'Você não tem permissão para excluir este registro' }, status: :forbidden
      end
    end

    private

      def create_params
          if current_user.admin?
            require_parameters([:name, :cnpj, :manager_id, :phone])
            params.permit(:name, :cnpj, :description, :manager_id, :phone)
          elsif current_user.manager?
            require_parameters([:name, :cnpj, :phone])
            params.permit(:name, :cnpj, :description, :phone)
          end
        end

        def update_params
          params.permit(:name, :description, :phone)
        end

end
