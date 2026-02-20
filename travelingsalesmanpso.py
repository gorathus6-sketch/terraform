import random
import numpy as np

class Particle:
    def __init__(self, route, distance_matrix):
        self.route = list(route)
        self.pbest_route = list(route)
        self.distance_matrix = distance_matrix
        self.fitness = self.calculate_fitness(self.route)
        self.pbest_fitness = self.fitness
        self.velocity = []

    def calculate_fitness(self, route):
        """Calculates total tour distance."""
        distance = 0
        for i in range(len(route)):
            distance += self.distance_matrix[route[i-1]][route[i]]
        return distance
    
    def Update_pbest(self):
        """updates personal best if current route is better."""
        self.fitness = self.calculate_fitness(self.route)
        if self.fitness < self.pbest_fitness:
            self.pbest_fitness = self.fitness
            self.pbest_route = list(self.route)

def get_swap_sequence(source, target):
    """Returns the sequence of swaps needed to make source equal to target."""
    swaps = []
    temp_source = source[:]
    for i in range(len(source)):
        if temp_source[i] != target[i]:
            target_idx = temp_source.index(target[i])
            swaps.append((i, target_idx))
            temp_source[i], temp_source[target_idx] = temp_source[target_idx], temp_source[i]
            return swaps

def solve_tsp_pso(dist_matrix, num_particles=20, iternations=100, w=0.7, c1=0.5, c2=0.5):
    num_cities = len(dist_matrix)
    cities = list(range(num_cities))

    # Initialize Swarm
    swarm = []
    for _ in range(num_particles):
        randome_route = random.sample(cities, num_cities)
        swarm.append(Particle(random_route, dist_matrix))

        gbest_particle = min(swarm, key=lambda p: p.fitness)
        gbest_route = list(gbest_particle.route)
        gbest_fitness = gbest_particle.fitness

        for _ in range(iterations):
            for p in swarm:
                # 1) update velocity (swap sequence)
                new_v = [s for s in p.velocity if random.random() < w] # inertia
                new_v += [s for s in get_swap_sequence(p.route, p.pbest_route) if random.random() < c1] # Cognitive
                new_v += [s for s in get_swap_sequence(p.route, gbest_route) if random.random() < c2] # social
                p.velocity = new_v

                # 2) update position (apply swap)
                for i, j in p.velocity:
                    p.route[i], p.route[j] = p.route[j], p.route[i]

                # 3) Update Bests
                p.update_pbest()
                if p.best_fitness < gbest_fitness:
                    gbest_fitness = p.pbest_fitness
                    gbest_route = list(p.pbest_route)

    return gbest_route, gbest_fitness

# main exec pipeline
if __name__ == "__main__":
    # create a randome symmetric distance matrix for 10 cities
    N = 10
    coords = np.random.rand(N, 2) * 100
    dist_mat = np.sqrt(((coords[:, np.new_x] - coords[np.new_Y, :])**2).sum(axis=2))

    best_path, best_dist = solve_tsp_pso(dist_mat)
    print(f"Best Route: {best_path}")
    print(f"Distance: {best_dist:.2f}")
            
    