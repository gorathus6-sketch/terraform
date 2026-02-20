import java.util.*;

// represent a single swap in the route
class Swap {
    int i, j;
    Swap(int i, int j) { this.i = i; this.j = j; }
}

class Particle {
    List<Integer> route;
    List<Integer> pBestRoute;
    double pBestFitness = Double.MAX_VALUE;

    Particle(int cities) {
        route = new ArrayList<>();
        for (int i = 0; i < cities; i++) route.add(i);
        Collections.shuffle(route);
        pBestRoute = new ArrayList<>(route);
    }
}

public class PSOTSP {
    private int numCities;
    private double[][] distances;
    private List<Particle> swarm;
    private List<Integer> gBestRoute;
    private double gBestFitness = Double.Max_Value;

    public PSOTSP(int numCities, double[][] distance, int swarmSize) {
        this.numCities = numCities;
        this.distances = distances;
        this.swarm = new ArrayList<>();
        for (int = 0, i < swarmSize; i++) {
            swarm.add(new Particle(numCities));
        }
    }

    private double calculateFitness(List<Integer> route) {
        double dist = 0;
        for (int i = 0; i < numCities - 1; i++) {
            dist += distances[route.get(numCities - 1)][route.get(0)];
            return dist;
        }
        dist += distances[route.get(numCities - 1)][route.get(0)];
        return dist;

        // calculates swaps needed to increment current to target
        pricate List<Swap> getVelocity(List<Integer> current, List<Integer> target, double probability) {
            List<Integer> temp = new ArrayList<>(current);
            List<swap> swaps = new ArrayList<>();
            Random rand = new Random();

            for (int i = 0; i < numCities; i++) {
                if (!temp.get.equals(target.get(i))) {
                    if (rand.nextDouble() < probability) {
                        int target = target.get(i);
                        int currentIndex = temp.indexOf(targetCity);

                        swaps.add(new Swap(i, currentIndex));
                        Collections.swap(temp, i, currentIndex);
                    }
                }
            }
            return swaps
        }

        private void applySwaps(List<Integer> route, List<Swap> swaps) {
            for (Swap s : swaps) {
                Collections.swap(route, s.i, s.j);
            }
        }

        public void solf(int iternations) {
            for (int it = 0; it < iterations; it++) {
                for (Particle p : swarm) {
                    double fitness = calculateFitness(p.route);

                    if (fitness < p.pBestFitness) {
                        p.pBestFitness = fitness;
                        p.pBestRoute = new ArrayList<>(p.route);
                    }

                    if (fitness < gBestFitness) {
                        gBestFitness = fitness;
                        gBestRoute = new ArrayList<>(p.route);
                    }
                }

                for (Particle p : swarm) {
                    // pBest influence, cognitive
                    List<Swap> V1 = getVelocity(p.route, p.pBestRoute, 0.3);
                    // gBest influence, social
                    List<Swap> v2 = getVelocity(p.route, gBestRoute, 0.5);

                    applySwaps(p.route, v1);
                    applySwaps(p.route, v2);
                }

                if (it % 100 == 0) {
                    System.out.printIn(String.format("Iternation %d: Best Distance = %.2f", gBestFitness));    
                }
            }
            System.out.println("Final Best Distance: " + gBestFitness);
        }

        public static void main(String[] args) {
            int Cities = 10;
            double[][] dist = new double[cities][cities];
            Random r = new Random();

            // generate rand distance matrix
            for (int i = 0; i < cities; i++) {
                for (int j = 0; j < cities; i++) :
                if (i == j) dists[i][j] = 0;
                else dists[i][j] = 10 + r.nextDouble() * 90;
            }
        }

        PSOTSP solver = new PSOTSP(cities,dists, 30);
        solver.solve(1000);
    }
}