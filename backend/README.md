# Backend

To start your Phoenix server:

## Manually / Debug
  * Install dependencies with `mix deps.get`
  * Start up a postgres instance (check upper directory on using `docker-compose up postgres`)
  * Create and migrate your database with `mix ecto.setup`
  * Seed the database with `mix ecto.seed`
  * Start Phoenix endpoint with `mix phx.server` or `iex -S mix phx.server`

## Through docker-compose
  * Navigate to root directory (one up from this)
  * Start dependencies, migrate db and run backend:
  ``` bash
  docker-compose up
  ```
  * To seed the database call:
  ```
  docker exec -it backend-exercise_backend_1 ./backend rpc Backend.Repo.Seeder.seed
  ```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

The client was also containerized so issuing `docker-compose up` will also start that container while exposing port 3000 on the host.
Access `http://localhost:3000` and everything should be up and running.
> :warning: This works in Windows and Mac environments. For Linux systems, replace `proxy` @ `/frontend/package.json`

<hr>

## API

The following API routes are exposed:

``` bash
curl -X GET http://localhost/api/users/:user_id

'{"user": {"user_id": "johndoe", "data": {"balance": 500, "product_ids": [...]}}}'
```

``` bash
curl -X GET http://localhost/api/products

'{"products": [{id: "netflix", "name": "Netflix", price: 75}, ...] }'

```

``` bash
curl -X POST http://localhost/api/orders -d '{"order": {"items": ["product-1", "product-2"], "user_id": "johndoe"}}'

200: '{"order": {"order_id": "123", "data": {"items": [...], "total": 500}}}'
400: '{"error": "products_not_found"}'
400: '{"error": "products_already_purchased"}'
400: '{"error": "insufficient_balance"}'
```

> As it stands today, the API is not RESTfull. Please check the `considerations` section

<hr>

## Tasks
``` bash
mix profile            # Runs benchmarks
mix setup              # Fetch dependencies and compile
mix test.all           # Runs all tests
mix test.integration   # Runs integration tests
mix test.unit          # Runs unit tests
mix verify             # Check formating, run tests, check code quality and vulnerabilities (your own compact, local CI)
mix vulns              # Check for vulnerabilities
```

<hr>

## Profiling

To profile low level system implementation (usefull for non functional testing) call:
``` elixir
mix profile
```

Results are returned on the console and also in html format.<br/>
Console results look like:
```
Operating System: Linux
CPU Information: Intel(R) Xeon(R) E-2276M  CPU @ 2.80GHz
Number of Available Cores: 12
Available memory: 31.73 GB
Elixir 1.11.2
Erlang 23.2.1

Benchmark suite executing with the following configuration:
warmup: 5 s
time: 5 s
memory time: 0 ns
parallel: 1
inputs: Get one
Estimated total run time: 40 s

[...]

##### With input Get one #####
Name             ips        average  deviation         median         99th %
100000        481.96        2.07 ms    ±41.31%        1.74 ms        4.79 ms
100           379.94        2.63 ms    ±25.76%        2.62 ms        4.26 ms
1000          296.35        3.37 ms    ±29.82%        3.70 ms        4.86 ms
10000         267.75        3.73 ms    ±15.70%        3.79 ms        4.96 ms

Comparison:
100000        481.96
100           379.94 - 1.27x slower +0.56 ms
1000          296.35 - 1.63x slower +1.30 ms
10000         267.75 - 1.80x slower +1.66 ms
```

Html results can be found under /backend/bench/out/...

<hr>

## Considerations

### Phoenix
Phoenix was used for ease of implementation and speed.<br/>
As PubSub, Telemetry, etc may not be needed, "downgrading" to plug+cowboy can provide some slight optimization (though I don't expect it to be perceptible).

### Ecto
Ecto was used more as a way for me to learn on how to use it. Seems to fit nicely, at first glance, in a more DDDish code structure by keeping all logic in the aggregate.<br/>
Had a somewhat hard time piecing some concepts together and didn't leverage Ecto to it's fullest - especially on the association part.<br/>
Opted out of assigning a hard relation between users and products for some reasons:
 1. Eases up on implementation
 2. Speeds up writes
 3. Persists over removed products
This last one isn't really a use-case for this exercise but something that may come later and we probably need to keep tabs on what users have bought

### Postgres
I initially though of used MongoDB just out of the small requirements on this exercise but thinking of operating it at scale.<br/>
Opted instead of using Postgres because of its common use with ecto and Phoenix (battle-proofed?) but also because scalling may not be an issue untill we hit the 100_000 product mark (takes 4s on my box. Not optimal but manageable).<br/>
Moving to no-sql should be considered after paginating results is attemped, imho.

### Logging
Opted out of any logs for sake of readability

### Resilience / Redundancy
Opted out of building any resilience other than what OTP offers.<br/>
For such a small scale, redundancy was also not considered.<br/>
Please check the `Scaling` section on `Extension points`

### REST API
I stood by the API contract asked though I find that some changes are needed.
 - `GET /api/users/:user_id` should not `PUT` a new user. Instead we should code that logic at the client
 - `POST /api/orders` should be a `PUT` instead ([rfc](https://tools.ietf.org/html/rfc7231))
 - `POST /api/orders` should return `201` instead on successfull creation

### CI
Docker was used for building the backend, frontend and supply dependencies like postgres.<br/>
Moving forward, testing could be done inside a container as well or on a build system (gh actions, circle, jenkins, etc...)<br/>
No code coverage was collected though ex_coveralls could have been used for example. As the exercise was mostly academic I didn't see the benefit of having it<br/>
Two images, coverflex/backend and coverflex/frontend come as arficats of running `docker-compose build`<br/>
Lastly, docker-compose was used for orchestration and that can be reused on docker swarm. Nothing was done for K8s. I wanted to dive on it but didn't find the time to :/

### Security
Ah, an interesting one. This is endless and I didn't even try to tackle it on this pass. <br/>
First thing would be to have authentication and authorization in place. Out of the top of my head, JWT claim tokens, for example ...and SSL :)<br/>
Once that's in place, we can start to think of having auditing and how to be GDPR compliant.

## Extension points

### Quick wins
Moving forward there are a couple of quick wins:
 - Telemetry
 - Expanding the API
 - Logging
 - Documentation (and Documentation as code with ExDoc)
 - CI/CD Pipeline

### Scaling
If scalling starts to be an issue (from testing, upper than `100_000` products, for example) some things can be done:
 - Paginated api results: This eases up database load and network traffic. Our frontend needs to start following links and handle pages of data.
 - Setting up a caching system also helps in offloading db and network
 - More complex but more scallable are multiple read models (projections) to a central write model. This optimizes reads over writes
 - Lateral scalling for load balancing (also redundancy): This allows for more concurrent user processing.
 - Additional to lateral scalling, sharding the database ensures higher scallability (geo-referencing even).

<hr>

## Thank you
Thanks for the challenge and the opportunity to learn new things. I enjoyed it!