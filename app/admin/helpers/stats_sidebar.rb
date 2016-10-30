# frozen_string_literal: true

module StatsSidebar
  def self.included(dsl)
    dsl.sidebar 'Estadísticas' do
      scope = dsl.controller.resource_class
      scope = scope.public_send(current_scope.scope_method) if current_scope

      div { "#{scope.last_day.size} en las últimas 24h" }
      div { "#{scope.last_week.size} en la última semana" }
      div { "#{scope.last_month.size} en el último mes" }
      div { "#{scope.last_year.size} en el último año" }
    end

    dsl.config.sidebar_sections.reverse!
  end
end
