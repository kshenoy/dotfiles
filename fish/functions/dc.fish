function __dc_down
    # Bring down services in the current project (or the project a named container belongs to, found
    # automatically via its compose label — service name and any trailing flags travel together in
    # one call). --all tears down every running project instead
    set -l extra $argv[2..]
    set -l container_dirs .

    if test "$argv[2]" = --all
        set extra $argv[3..]
	# Working dir of every currently-running compose project (deduped, so a multi-container
	# project like qbittorrent only shows up once)
        set container_dirs (for c in (docker ps --format '{{.Names}}')
            docker inspect $c --format '{{index .Config.Labels "com.docker.compose.project.working_dir"}}' 2>/dev/null
        end | sort -u)
    end

    set -l prev_dir (pwd)
    for dir in $container_dirs
        echo "==> $dir"
        cd $dir
        sudo docker compose down $extra
	if test "$argv[1]" = "du"
            sudo docker compose up -d $extra
        end
    end
    cd $prev_dir
end

function dc
    # Docker Compose helper function
    # Usage: dc <command> [service] [args]
    # Usage: dc d/du --all   (runs the command across every running compose project)

    switch $argv[1]
        case d
            __dc_down $argv

        case u
            # Bring up all services (or a specific one) in detached mode
            if test "$argv[2]" = --all
                echo "dc u --all: not supported — --all discovers projects from running containers, so there's nothing to find for stopped ones" >&2
                return 1
            else
                sudo docker compose up -d $argv[2..]
            end

        case du
            __dc_down $argv

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
            echo "  d   [service|--all] Bring down services (--all: every running compose project)"
            echo "  du  [service|--all] Bring down then back up (--all: every running compose project)"
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

