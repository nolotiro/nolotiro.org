# frozen_string_literal: true

module SocialDupUsernameTests
  def setup
    super

    create(:user, username: "pepe", email: "pepe@example.org")
    login_via(@provider, name: "pepe", email: "pepe@example.com")
  end

  def test_redirects_to_a_form
    assert_text <<~MSG
      Tu nombre de usuario de #{@provider} ya se encuentra en nuestra base de
      datos. Si te has registrado ya usando otra red social o mediante email y
      contraseña, por favor, inicia sesión de esa manera. En caso contrario,
      indica otro nombre de usuario para completar el registro.
    MSG
  end

  def test_finalizes_registration_properly
    fill_in "Elige un nombre de usuario", with: "pepe_nolotiro"
    click_button "Regístrate"

    assert_link "pepe_nolotiro"
  end
end
