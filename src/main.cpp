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
	sf::RenderWindow app(sf::VideoMode(800,600,32), "Shaders", sf::Style::Close | sf::Style::Resize);

	sf::Shader shader;
	shader.LoadFromFile("../data/underwater.glsl")
			|| die("Shader not found or loading failed.");
    shader.SetTexture("tex", sf::Shader::CurrentTexture);

	sf::Image image;
	image.LoadFromFile("../data/underwater.jpg")
			|| die("Image not found or loading failed.");

    sf::Sprite sprite(image);
    sprite.Resize(800,600);

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
        app.Draw(sprite, shader);
        app.Display();


	}

    return 0;
}
