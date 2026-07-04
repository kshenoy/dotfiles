function __dc_down
    sudo docker compose down $argv
end

function __dc_up
    sudo docker compose up -d $argv
end

function dc
    # Docker Compose helper function
    # Usage: dc <command> [service] [args]

    switch $argv[1]
        case d
            # Bring down services. If followed by 'u', restart (down then up)
            __dc_down $argv[2..]

        case u
            # Bring up all services (or a specific one) in detached mode
            __dc_up $argv[2..]

        case du
            # Bring down services and then bring them back up
            __dc_down $argv[2..]
            __dc_up $argv[2..]

        case lg
            # Follow logs for all services or a specific one
            sudo docker compose logs -f $argv[2..]

        case ps
            # List all running containers on the host (across all compose projects)
            sudo docker ps -a --format "table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.Ports}}" $argv[2..]

        case p.
            # List containers in the current compose project, with health status
            sudo docker compose ps -a --format "table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.Ports}}" $argv[2..]

        case ex
            # Open a sh shell inside a running container
            sudo docker exec -it $argv[2] sh

        case eb
            # Open a bash shell inside a running container
            sudo docker exec -it $argv[2] bash

        case img
            # List all Docker images on the host
            sudo docker images

        case prune
            # Remove all stopped containers, unused images, networks, and volumes
            sudo docker system prune -af --volumes

        case stats
            # Show a snapshot of resource usage (CPU, memory) for all running containers
            sudo docker stats --no-stream

        case '*'
            echo "dc — Docker Compose helper"
            echo ""
            echo "Usage: dc <command> [service] [args]"
            echo ""
            echo "Compose commands (scoped to current compose project):"
            echo "  u   [service]       Bring up services in detached mode"
            echo "  d   [service]       Bring down services"
            echo "  du  [service]       Bring down then back up (full restart, picks up config changes)"
            echo "  lg  [service]       Follow logs"
            echo "  p.                  List containers in this compose project"
            echo ""
            echo "Exec commands:"
            echo "  ex  <container>     Shell into a container (sh)"
            echo "  eb  <container>     Shell into a container (bash)"
            echo ""
            echo "Global Docker commands (all containers on host):"
            echo "  ps                  List all running containers including stopped"
            echo "  img                 List all images"
            echo "  stats               Show CPU/memory usage snapshot"
            echo "  prune               Remove all unused containers, images, networks, and volumes"
    end
end

