#include <string>
#include <iostream>

#include <SFML/Graphics.hpp>
#include <SFML/System.hpp>
#include <SFML/Window.hpp>

bool die(std::string msg) {
	std::cerr << std::endl << "Exit: " << msg << std::endl;
	exit(1);
	return false;
}

int main() {
	sf::RenderWindow app(sf::VideoMode::GetDesktopMode(), "Shaders", sf::Style::Fullscreen);
	app.SetFramerateLimit(60);

	sf::Shader shader;
	shader.LoadFromFile("../data/underwater.glsl")
			|| die("Shader not found or loading failed.");
    shader.SetTexture("tex", sf::Shader::CurrentTexture);

	sf::Image image;
	image.LoadFromFile("../data/underwater.jpg")
			|| die("Image not found or loading failed.");

	sf::Sprite sprite(image);
	sprite.Resize(app.GetWidth(),app.GetHeight());

	bool shader_enabled = true;

    sf::Clock clock;
    float time;

	while(app.IsOpened()) {
        float time_delta = clock.GetElapsedTime();
        clock.Reset();
        time += time_delta;
        
        shader.SetParameter("total_time", time);

		sf::Event event;
		while(app.GetEvent(event)) {
			if(event.Type == sf::Event::Closed) {
				app.Close();
			} else if(event.Type == sf::Event::KeyPressed) {
				if(event.Key.Code == sf::Key::Escape) {
					app.Close();
				} else if(event.Key.Code == sf::Key::Space) {
					shader_enabled = !shader_enabled;
				}
			}
		}

        app.Clear();
		if(shader_enabled) {
			app.Draw(sprite, shader);
		} else {
			app.Draw(sprite);
		}


        app.Display();


	}

    return 0;
}
