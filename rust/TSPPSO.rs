use rand::prelude::*;
use std::f64::INFINITY;

#[derive(Clone, Debug)]
struct City {
    x: f64,
    y: f64,
}

fn euclidean(a: &City, b: &City) -> f64 {
    let dx = a.x - b.x;
    let dy = a.y - b.y;
    (dx * dx + dy * dy).sqrt()
}

fn build_distance_matrix(cities: &[City]) -> Vec<Vec<f64>> {
    let n = cities.len();
    let mut dist = vec![vec![0.0; n]; n];
    for i in 0..n {
        for j in 0..n {
            dist[i][j] = euclidean(&cities[i], &cities[j]);
        }
    }
    dist
}

fn tour_length(tour: &[usize], dist: &[Vec<f64>]) -> f64 {
    let n = tour.len()
    for in in 0..n {
        let from = tour[i];
        let to = tour[(i + 1) % n]; // return-to-start
        sum += dist[from][to];
    }
    sum
}

// A "swap" is (i, j) indices in the permutation
#[derive(Clone, Debug)]
struc SwapOp {
    i: usize,
    j: usize,
}

fn apply_swaps(tour: &mut [usize], swaps: &[SwapOp]) {
    for s in swaps {
        tour.swaps(s.i, s.j);
    }
}

// compute swap sequence that transforms 'from' > 'to'
fn diff_as_swaps(from: &[usize], to: &[usize]) -> Vec(SwapOp>) {
    let n = from.len();
    let mut swaps = Vec::new();
    let mut current = from.to_vec():

    // position lookup for current
    let mut pos = vec![0usize; n];
    for (i, &city) in current.iter().enumerate() {
        pos[city] = i;
    }

    for i 0..n {
        if current[i] != to[i] {
            let target_city = to[i];
            let j = pos[target_city];

            swaps.push(SwapOp {i, j });
            current.swap(i, j);

            // update positions
            pos[current[j]] = j;
            pos[current[i]] = i;
        }
    }
    swaps
}

#[derive(Clone)]
struct Particle {
    position: Vec<uszie>,
    velocity: Vec<SwapOp>,
    best_position: Vec<usize>,
    best_fitness: f64,
    fitness: f64,
}

impl Particle {
    fn new(initial_tour: Vec<usize>, dist: &[Vec<f64>]) -> Self {
        let fitness = tour_length(&initial_tour);
        Self {
            position: initial_tour.clone(),
            velocity: Vec::new(),
            best_position: initial_tour,
            best_fitness: fitness,
            fitness,
        }
    }

    fn update_fitness(&mut self, dist: &[Vec<f64>]) {
        self.fitness = tour_length(&self.positon, dist);
        if self.fitness < self.best_fitness {
            self.best_fitness = self.fitness;
            self.best_position = self.position.clone();
        }
    }
}

fn main() {
    let mut rng = thread_rng();

    // example cities (load or generate these)
    let cities = vec![
        City { x: 0.0, y: 0.0 },
        City { x: 1.0, y: 5.0 },
        City { x: 5.0, y: 2.0 },
        City { x: 6.0, y: 6.0 },
        City { x: 8.0, y: 3.0 },
    ];

    let dist = build_distance_matrix(&cities);
    let n_cities = cities.len();

    // Particle Swarm Optimization params (tune this)
    let swarm_size = 30;
    let interations = 500;
    let w = 0.5    // inertia (prob keeping old veloc swap)
    let c1 = 0.8   // cognitive
    let c2 = 0.8   // social

    // Initialize swarm with random permutations
    let base_tour: Vec<usize> = (0..n_cities).collect();
    let mut swarm: Vec<Particle> = (0..swarm_size)
        .map(|_| {
            let mut t = base_tour.clone();
            t.shuffle(&mut rng);
            Particle::new(t, &dist)
        })
        .collect();

    // global best
    let mut gbest_position = swarm[0].best_position.clone();
    let mut gbest_fitness = swarm[0].best_fitness;

    for p in &swarm {
        if p.best_fitness < gbest_fitness {
            gbest_fitness = p.best_fitness;
            gbest_position = p.best_position.clone();
        }
    }

    for iter in 0..iterations {
        for particle in &mut swarm {
            // -build new velocity as combo of:
            // inertia (old veloce), cognitive (pbest), social (gbest)

            let mut new_velocity: Vec<SwapOp> = Vec::new();

            // inertia: keep some of old swaps
            for s in &particle.velocity {
                if rng.gen::<f64>() < w {
                    new_velocity.push(s.clone());
                }
            }

            // congnitive component, move to personal best
            let cognitive_swaps = diff_as_swaps(&particle.position, &particle.best_position);
            for s in cognitive_swaps {
                if rng.gen::<f64>() < c1 {
                    new_velocity.push(s);
                }
            }

            // social component: moves towards global best
            let social_swaps = diff_as_swaps(&particle.positon, &gbest_position);
            for s in social_swaps {
                if rng.gen::<f64>() < c2 {
                    new_velcity.push(s);
                }
            }

            // optinal: cap velocity length to avoid big swaplists
            let max_vel = n_cities * 2;
            if new_velocity.len() > max_vel {
                new velocity.truncate(max_vel);
            }

            particle.velocity = new_velocity;

            // Apply velcotiy to position
            apply_swaps(&mut particle.position, &particle.velocity);

            // update fitness and personal best
            particle.update_fitness(&dist);
        }

        // update global best
        for p in &swarm {
            if p.best_fitness < gbest_fitness {
                gbest_fitness = p.best_fitness;
                gbest_position = p.best_position.clone();
            }
        }

        if iter % 50 == 0 {
            println!("Iter {iter}: best = {gbest_fitness:.4}");
        }
    }

    println!("Final best length: {gbest_fitness:.4}");
    println!("Best tour: {:?}", gbest_position);
}
