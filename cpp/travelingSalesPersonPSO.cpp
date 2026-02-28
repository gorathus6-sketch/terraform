#include <iostream>
#include <vector>
#include <algorithm>
#include <random>

// define particle
struct Particle {
    std::vector<int> position; // current route
    std::vector<int> pBest;    // personal best route
    double pBestCost;          // Best distance found by the particle
};

// function to calculate total route distance
double calculateDistance(const std::vector<int>& route, const std::vector<std::vector<double>>& distMatrix) {
    double total = 0.0;
    for (size_t i = 0; i < route.size() - 1; ++i) {
        total += distMatrix[route[i]][route[i+1]];
    }
    // return to the beginning
    total += distMatrix[route.back()][route[0]];
    return total;
}

int main() {
    // 1) setup random ops
    std::random_device rd;
    std::mt19937 g(rd());

    // 2) Initialize Particles
    int numCities = 5;
    std::vector<int> initialRoute = {0, 1, 2, 3, 4};

    Particle p;
    p.position = initialRoute;
    std::shuffle(p.position.begin(), p.position.end(), g);
    p.pBest = p.position;

    // 3) print result
    std::cout << "Initial Particle Route: ";
    for (int city : p.position) {
        std::cout << city << " ";
    }

    return 0;
}
